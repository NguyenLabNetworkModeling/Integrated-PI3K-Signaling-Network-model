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
t_drug      = linspace(0,24*60,500) + t_stim(end);
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



%% Simulation

% PARFOR WITH NESTED FOR-LOOP
n1d     = length(icx_range);
n2d     = length(icx_range);
n3d     = size(byl_combo,1); % BYL + x (n=24)
n4d     = length(markerproteins); % (n = 2)
n5d     = size(param_sets,2);
% total runs: 59136
% data structure
% d1: icx
% d2: icx
% d3: combo
% d4: markerproteins
% d5: model

tic
parfor masterIDX=1:(n1d*n2d*n3d*n4d*n5d)
    
    disp(masterIDX)
    
    [idx1,idx2,idx3,idx4,idx5]  = ind2sub([n1d,n2d,n3d,n4d,n5d],masterIDX);    
    
    param_vals      = param_sets(:,idx5);    
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

[nrow,ncol,~]   = size(mex_starv);
sim_starv       = reshape(mex_starv,[nrow,ncol,n1d,n2d,n3d,n4d,n5d]);

[nrow,ncol,~]   = size(mex_stim);
sim_stim        = reshape(mex_stim,[nrow,ncol,n1d,n2d,n3d,n4d,n5d]);

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

%%  plot and save

% script function ()
icx_dose_response

fname   = strcat(fullfile(workdir,'Outcome'),'\dose-responses-icx-parental_general','.mat');
save(fname,'drug_response_icx_general');
