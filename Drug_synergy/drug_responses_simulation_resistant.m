%% run estimate IC 50 (resistant cells)

%%
% Load best-fitted parameters

% LOAD PARAM SETS
filename    = 'Best_Fitted_Param_Sets_77_MOD_kc2_rt_020b.csv';
par_vals    = csvread(filename,0,0);
param_sets  = par_vals(:,2:end)';

% FULL MEDIA GROWING CONDITION
X0(strcmp(STATE_names,{'IGF'}))=13;
X0(strcmp(STATE_names,{'HRG'}))=1;

%%
% simulation time frame (Q-stimulation)

QTime = param_sets((strcmp(PARAM_name,'IGF_on_time')),1);
QTime = param_sets((strcmp(PARAM_name,'HRG_on_time')),1);

t_starv     = linspace(0,QTime,500);
t_stim      = linspace(0,500*60,3000) + t_starv(end);
tspan       = sort(unique([t_starv t_stim]));

% Q-stimulation --> Drug response
tspan_drug      = linspace(0,24*60,500);



% load drug lists
inhibitors  = readtable('model_target_drug_list.xlsx','ReadVariableNames',true);
drugs       = inhibitors.Drug;
drugON      = inhibitors.DrugON;
dose_range  = 10.^[-6 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9];



% main readouts
readouts_0      = {'phosphoRB','totalCd'};
% assuming pRB and cyclin D1 as a represenative marker proteins of cell
% viability
readouts_idx    = find(ismember(VARIABLE_name,readouts_0));
readouts        = VARIABLE_name(readouts_idx);


%% Simulation

n1d     = length(dose_range);
n2d     = length(drugs);
n3d     = size(param_sets,2);
% totla run = 15 * 25 * 77 = 28,875

tic
parfor masterIDX=1:(n1d*n2d*n3d)
    
    disp(masterIDX)
    % model_param_sets=param_sets;
    
    
    % Subscripts from linear index
    [idx1,idx2,idx3]=ind2sub([n1d,n2d,n3d],masterIDX);
    
    P0  = param_sets(:,idx3);
    
    %%%% Sim-1: growing condition %%%%
    P0(strcmp(PARAM_name,'BYL719'))         =0;
    P0(strcmp(PARAM_name,'BYL719_on_time')) =0;
    
    % ODE solver (MEX)
    try
        mex_output  = pi3k_networkmodel(tspan,X0,P0',mex_options);
        stim_tss    = mex_output.statevalues;
    catch
        stim_tss    = ones(length(tspan),length(VARIABLE_name))*NaN;
    end
    X0_2=stim_tss(end,:);
    
    
    
    
    %%%% Sim-2: Drug  treatment %%%%
    % 1) customization of the parental model to resistance
    X0_2    = Customization_Resistant_Model(X0_2,STATE_names);
    
    % drug treatment (drug, drug ON time)
    dd_idx          = strcmp(PARAM_name,drugs{idx2});
    dd_on_idx       = strcmp(PARAM_name,drugON{idx2});
    P0(dd_idx)      = dose_range(idx1);
    P0(dd_on_idx)   = 0;
    
    % it is still under 'growing condition'
    P0(strcmp(PARAM_name,'IGF_on_time'))=0;
    P0(strcmp(PARAM_name,'HRG_on_time'))=0;
    
    % ODE solver (MEX)
    try
        mex_output      = pi3k_networkmodel(tspan_drug,X0_2,P0',mex_options);
        variable_values = mex_output.variablevalues;
    catch
        variable_values = ones(length(tspan_drug),length(VARIABLE_name))*NaN;
    end
    mex_drug(:,:,masterIDX) = variable_values(:,readouts_idx);
    
    
    
    %%%% Sim-3: DMSO of the resistant cells  %%%%
    dd_idx          = strcmp(PARAM_name,drugs{idx2});
    dd_on_idx       = strcmp(PARAM_name,drugON{idx2});
    P0(dd_idx)      = 0;
    P0(dd_on_idx)   = 0;
    
    P0(strcmp(PARAM_name,'IGF_on_time'))    = 0;
    P0(strcmp(PARAM_name,'HRG_on_time'))    = 0;
    
    
    % ODE solver (MEX)
    try
        mex_output  = pi3k_networkmodel(tspan_drug,X0_2,P0',mex_options);
        variable_values     = mex_output.variablevalues;
    catch
        variable_values     = ones(length(tspan_drug),length(VARIABLE_name))*NaN;
    end
    mex_dmso(:,:,masterIDX) = variable_values(:,readouts_idx);
    
end

elapsed_time = toc/60; % (about 7.2 min)


%% reshape the parfor-results

[nrow,ncol,~]   = size(mex_drug);
Outcome_drug    = reshape(mex_drug,[nrow,ncol,n1d,n2d,n3d]);

[nrow,ncol,~]   = size(mex_dmso);
Outcome_dmso    = reshape(mex_dmso,[nrow,ncol,n1d,n2d,n3d]);

% normalized to dmso
sim_drug_adj = Outcome_drug./Outcome_dmso;
% data structure
% d1: time
% d2: variables (readouts)
% d3: dose range (n=15)
% d4: drugs (n = 25)
% d5: models (n=77)




% plot the drug response 

for ii=1:size(sim_drug_adj,2)
    
        fig = figure('position',[265          95        1233         884]);

        for jj=1:size(sim_drug_adj,4)
            
            % note: dos-responses at 24 hr
            dat_mat(:,:)=sim_drug_adj(end,ii,:,jj,:);
            % normalization
            dat_mat_norm = dat_mat./repmat(dat_mat(1,:),size(dat_mat,1),1);
            
            subplot(5,5,jj),
            semilogx(dose_range,dat_mat_norm)
            xlabel(drugs{jj}),
            ylabel('normalized')
            figtitle(readouts{ii})
            pbaspect([4 3 1]/4)
            ytickformat('%.1f')
            box off
        end
end


% save data
drug_response.data      = sim_drug_adj;
drug_response.range     = dose_range;
drug_response.drug      = inhibitors;
drug_response.readout   = readouts;
drug_response.time      = tspan_drug;

fname = strcat(fullfile(workdir,'Outcome'),'\dose-responses-data-resistant','.mat');
save(fname,'drug_response');
