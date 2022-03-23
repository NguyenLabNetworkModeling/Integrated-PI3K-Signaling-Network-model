%% Calculation of CDI score (resistant cells)

%%
% Load best-fitted parameters

% LOAD PARAM SETS
filename    = 'Best_Fitted_Param_Sets_77_MOD_kc2_rt_020b.csv';
par_vals    = csvread(filename,0,0);
param_sets  = par_vals(:,2:end)';



% Full medium condition
X0(strcmp(STATE_names,'IGF'))=13;
X0(strcmp(STATE_names,'HRG'))=1;

%%
% simulation time frame (Q-stimulation)

QTime = param_sets((strcmp(PARAM_name,'IGF_on_time')),1);
QTime = param_sets((strcmp(PARAM_name,'HRG_on_time')),1);

t_starv     = linspace(0,QTime,500);
t_stim      = linspace(0,500*60,300) + t_starv(end);
tspan       = sort(unique([t_starv t_stim]));
% t_drug      = [0 6 12 24 48 72 96]*60;
tspan_drug      = linspace(0,24*60,500);

% % time points after stimulation
t_idx_strv  = tspan<=t_stim(1);
t_idx_stim  = and(tspan>=t_stim(1),tspan<=t_stim(end));

%%
% LOAD THE ESTIMATED IC50 VALS

%load ic50matrix
load ic50matrix_resistant_new

ic50_matrix     = ic50matrix_resistant_new.ic50;
markerproteins  = ic50matrix_resistant_new.readout;

% load drug lists
inhibitors  = readtable('model_target_drug_list.xlsx','ReadVariableNames',true);
drugs       = inhibitors.Drug;
drugON      = inhibitors.DrugON;


% for general variables (pS6, ....)
my_protein   = {'phosphoS6','phosphoS6K','phosphoErk','phosphoRB','totalCd'};
var_idx      = find(ismember(VARIABLE_name,my_protein));
my_variables = VARIABLE_name(var_idx);

icx_range       = [0 0.5 1 1.5];

% all  DRUG COMBINATIONS (25C2 = 300)
drug_combo=nchoosek(1:length(drugs),2);
% find combo (BYL + x)
% Note: BYL index = 1
byl_combo = drug_combo(ismember(drug_combo(:,1),1),:);


%% Simulation

n1d     = length(icx_range);
n2d     = length(icx_range);
n3d     = size(byl_combo,1); % BYL + x (n=24)
n4d     = length(markerproteins); % (pRB and cyclin D1)
n5d     = size(param_sets,2);
% total runs: 59136

% data structure
% d1: icx
% d2: icx
% d3: combo (n = 24)
% d4: markerproteins (n=2) used to estimate IC50
% d5: model (n = 77)


tic
parfor masterIDX=1:(n1d*n2d*n3d*n4d*n5d)
    
    disp(masterIDX)
    
    [idx1,idx2,idx3,idx4,idx5]=ind2sub([n1d,n2d,n3d,n4d,n5d],masterIDX);
        
    param_vals  = param_sets(:,idx5);
    
    
    %%%% Sim-1: growing condition %%%%
    % initial values
    param_vals(strcmp(PARAM_name,'BYL719'))         =0;
    param_vals(strcmp(PARAM_name,'BYL719_on_time')) =0;
    
    try
        mex_output  = pi3k_networkmodel(tspan,X0,param_vals',mex_options);
        stim_tss    = mex_output.statevalues;
    catch
        stim_tss    = ones(length(tspan),length(VARIABLE_name))*NaN;
    end
    
    X0_2    = stim_tss(end,:);
    
    
    
    %%%% Sim-2: BYL treatment %%%%
    % 1) customization of the parental model to resistance
    X0_2    = Customization_Resistant_Model(X0_2,STATE_names);
        
    % drug treatment (drug, drug ON time)
    comb_idx    = byl_combo(idx3,:);
    icx_1       = icx_range(idx1);
    icx_2       = icx_range(idx2);
    dose_1      = ic50_matrix(idx4,comb_idx(1),idx5)*icx_1;
    dose_2      = ic50_matrix(idx4,comb_idx(2),idx5)*icx_2;
    if any(isnan([dose_1 dose_2]))
        param_vals = param_vals * NaN;
    end
    param_vals((strcmp(PARAM_name,drugs{comb_idx(1)})))     = dose_1;
    param_vals((strcmp(PARAM_name,drugs{comb_idx(2)})))     = dose_2;
    param_vals((strcmp(PARAM_name,drugON{comb_idx(1)})))    = 0;
    param_vals((strcmp(PARAM_name,drugON{comb_idx(2)})))    = 0;
    
    param_vals(strcmp(PARAM_name,'IGF_on_time'))    =0;
    param_vals(strcmp(PARAM_name,'HRG_on_time'))    =0;
    
    
    % ODE solver (MEX)
    try
        mex_output      = pi3k_networkmodel(tspan_drug,X0_2',param_vals',mex_options);
        variable_values = mex_output.variablevalues;
    catch
        variable_values = ones(length(tspan_drug),length(VARIABLE_name))*NaN;
    end
    
    % response profile before stimulation
    mex_drug(:,:,masterIDX)=variable_values(:,var_idx);
    
    
    
    
    
    %%%% Sim-3: DMSO of the resistant cells  %%%%
    param_vals((strcmp(PARAM_name,drugs{comb_idx(1)})))     =0;
    param_vals((strcmp(PARAM_name,drugs{comb_idx(2)})))     =0;
    param_vals((strcmp(PARAM_name,drugON{comb_idx(1)})))    =0;
    param_vals((strcmp(PARAM_name,drugON{comb_idx(2)})))    =0;
    
    param_vals(strcmp(PARAM_name,'IGF_on_time'))=0;
    param_vals(strcmp(PARAM_name,'HRG_on_time'))=0;
    
    % ODE solver (MEX)
    try
        mex_output      = pi3k_networkmodel(tspan_drug,X0_2,param_vals',mex_options);
        variable_values = mex_output.variablevalues;
    catch
        variable_values = ones(length(tspan_drug),length(VARIABLE_name))*NaN;        
    end
    
    % response profile before stimulation
    mex_dmso(:,:,masterIDX) = variable_values(:,var_idx);
    
end

elapsed_time= toc/60; % about 10 min




%%
% RESHAPTING THE OUTCOME

[nrow,ncol,~] = size(mex_drug);
sim_drug_0    = reshape(mex_drug,[nrow,ncol,n1d,n2d,n3d,n4d,n5d]);

[nrow,ncol,~] = size(mex_dmso);
sim_dmso      = reshape(mex_dmso,[nrow,ncol,n1d,n2d,n3d,n4d,n5d]);
% adjust 
sim_drug      = sim_drug_0./sim_dmso;
% data structure ----
% d1: time
% d2: icx
% d3: icx
% d4: combo (n = 24)
% d5: readout (n=2)
% d6: model (n = 77)

%% plot and save

icx_dose_response

fname = strcat(fullfile(workdir,'Outcome'),'\dose-responses-icx-resistant_general','.mat');
save(fname,'drug_response_icx_general');
