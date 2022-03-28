%% Calculation of CDI score (parental cells)

% LOAD PARAM SETS
filename='Best_Fitted_Param_Sets_77_MOD_kc2_rt_020b.csv';
par_vals = csvread(filename,0,0);
param_sets = par_vals(:,2:end)';


% Full medium condition
X0(strcmp(STATE_names,'IGF'))=13;
X0(strcmp(STATE_names,'HRG'))=1;

%%
% simulation time frame (Q-stimulation)

QTime = param_sets((strcmp(PARAM_name,'IGF_on_time')),1);
QTime = param_sets((strcmp(PARAM_name,'HRG_on_time')),1);

% natural response (no stimulation)
t_starv     = linspace(0,QTime,500);
t_stim      = linspace(0,500*60,3000) + t_starv(end);
t_drug      = [0 12 24 48 72] + t_stim(end);
tspan       = sort(unique([t_starv t_stim t_drug]));

% time points after stimulation
t_idx_strv  = tspan<=t_stim(1);
t_idx_stim  = and(tspan>=t_stim(1),tspan<=t_drug(1));
t_idx_drug  = tspan>=t_drug(1);

tspan_strv  = tspan(t_idx_strv);
tspan_stim  = tspan(t_idx_stim)-t_stim(1);
tspan_drug  = tspan(t_idx_drug)-t_drug(1);
%%
% LOAD THE ESTIMATED IC50 VALS

% load ic50matrix
% load ic50matrix_parental
load ic50matrix_parental_new

ic50_matrix     = ic50matrix_parental_new.ic50;
markerproteins  = ic50matrix_parental_new.readout;

% load drug lists
inhibitors  = readtable('model_target_drug_list.xlsx','ReadVariableNames',true);
drugs       = inhibitors.Drug;
drugON      = inhibitors.DrugON;

% for general variables (pS6, ....)
my_protein = {'phosphoS6','phosphoS6K','phosphoErk','phosphoRB','totalCd'};
var_idx     = find(ismember(VARIABLE_name,my_protein));
my_variables    = VARIABLE_name(var_idx);

icx_range   = [0 0.5 1 1.5];


% ALL POSSIBLE DRUG COMBINATIONS (25C2 = 300)

drug_combo=nchoosek(1:length(drugs),2);
% find combo (BYL + x)
% Note: BYL index = 1
byl_combo = drug_combo(ismember(drug_combo(:,1),1),:);



%% Generate a random matrix


num_rand    = 5; % number of random repeat
ptr_size    = 50; % perturbation size (e.g., +/-50%)
ub          = ptr_size/100; % upper boundary
lb          = -ptr_size/100; % lower bunder

for ii = 1:num_rand
    
    rng(ii)
    
    rand_mat(:,:,ii) = 1 - (ub-(ub-lb)*rand(140,size(param_sets,2)));
end



for ii = 1:num_rand
    
    % apply the random value
    param_sets_prt = param_sets;
    param_sets_prt(1:140,:) = param_sets_prt(1:140,:).* rand_mat(:,:,ii);
    
    %% Simulation
    
    % PARFOR WITH NESTED FOR-LOOP
    n1d     = length(icx_range);
    n2d     = length(icx_range);
    n3d     = size(byl_combo,1); % BYL + x (n=24)
    n4d     = length(markerproteins); % (n = 2)
    n5d     = size(param_sets_prt,2); % (n = 77)
    
    % total runs: 59136
    % data structure
    % d1: icx
    % d2: icx
    % d3: combo
    % d4: markerproteins
    % d5: model
    
    tic
    parfor masterIDX=1:(n1d*n2d*n3d*n4d*n5d)
        
        disp(strcat('r=',num2str(ii),{'   '},'c=',num2str(masterIDX)))
        
        [idx1,idx2,idx3,idx4,idx5]  = ind2sub([n1d,n2d,n3d,n4d,n5d],masterIDX);
        
        param_vals      = param_sets_prt(:,idx5);
        
        
        
        drug_comb_idx   = byl_combo(idx3,:);
        icx_1   = icx_range(idx1);
        icx_2   = icx_range(idx2);
        dose_1  = ic50_matrix(idx4,drug_comb_idx(1),idx5)*icx_1;
        dose_2  = ic50_matrix(idx4,drug_comb_idx(2),idx5)*icx_2;
        
        if any(isnan([dose_1 dose_2]))
            param_vals = param_vals * NaN;
        end
        
        param_vals((strcmp(PARAM_name,drugs{drug_comb_idx(1)})))    = dose_1;
        param_vals((strcmp(PARAM_name,drugs{drug_comb_idx(2)})))    = dose_2;
        param_vals((strcmp(PARAM_name,drugON{drug_comb_idx(1)})))   = t_stim(end);
        param_vals((strcmp(PARAM_name,drugON{drug_comb_idx(2)})))   = t_stim(end);
        
        % ODE solver (MEX)
        try
            mex_output  = pi3k_networkmodel(tspan,X0,param_vals',mex_options);
            variable_values = mex_output.variablevalues;
        catch
            variable_values = ones(length(tspan),length(VARIABLE_name)) * NaN;
        end
        
        % response profile before stimulation
        mex_starv(:,:,masterIDX)    = variable_values(t_idx_strv,var_idx);
        mex_stim(:,:,masterIDX)     = variable_values(t_idx_stim,var_idx);
        mex_drug(:,:,masterIDX)     = variable_values(t_idx_drug,var_idx);
    end
    
    elapsed_time= toc/60; % about 21 min
    
    
    
    %%
    % RESHAPTING THE OUTCOME
    [nrow,ncol,~]   = size(mex_drug);
    sim_drug        = reshape(mex_drug,[nrow,ncol,n1d,n2d,n3d,n4d,n5d]);
    % data structure
    % d1: time
    % d2: variables (pS6 and pS6K, ...)
    % d3: icx (n = 4)
    % d4: icx (n = 4)
    % d5: combo (n = 24)
    % d6: markerproteins (n = 2)
    % d7: model (n = 77)
    
    
    
    
    
    %% CALCULATION OF CDI (SYNERGY)
    
    n1d     = length(icx_range); % icx (n = 4)
    n2d     = size(byl_combo,1); % BYL + x (n=24); % combination
    n3d     = length(markerproteins); % (markerproteins for ic50, n = 2)
    n4d     = size(param_sets,2); % model (n = 77)
    n5d     = length(my_variables); % (variables, n = 5)
    
    parfor masterIDX=1:(n1d*n2d*n3d*n4d*n5d)
        
        disp(masterIDX)
        
        % Subscripts from linear index
        [idx1,idx2,idx3,idx4,idx5]   = ind2sub([n1d,n2d,n3d,n4d,n5d],masterIDX);
        % at 24 hr
        cont_R0     = sim_drug(end,idx5,1,1,idx2,idx3,idx4);
        % data structure
        % d1: time (500)
        % d2: icx (4)
        % d3: icx (4)
        % d4: combo (24)
        % d5: variables (2)
        % d6: model (77)
        single_R1(masterIDX)    = sim_drug(end,idx5,idx1,1,idx2,idx3,idx4)/cont_R0;
        single_R2(masterIDX)    = sim_drug(end,idx5,1,idx1,idx2,idx3,idx4)/cont_R0;
        comb_R12(masterIDX)     = sim_drug(end,idx5,idx1,idx1,idx2,idx3,idx4)/cont_R0;
        CDI(masterIDX)          = comb_R12(masterIDX)./(single_R1(masterIDX).*single_R2(masterIDX));
        
    end
    
    CDI_score       = reshape(CDI,[n1d,n2d,n3d,n4d,n5d]);
    % data structure
    % d1: icx (4)
    % d2: combo (24)
    % d3: markerproteins (2)
    % d4: model (77)
    % d5: variables (n = 5)    
    CDI_score_c{ii}     = CDI_score;
    
end

fname   = strcat(fullfile(workdir,'Outcome'),'\cdi-score_perturbation_',num2str(ptr_size),'.mat');
save(fname,'CDI_score_c');





