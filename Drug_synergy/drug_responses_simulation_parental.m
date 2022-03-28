%% run estimate IC 50 (parental cells)

%% 
% Load best-fitted parameters

% LOAD PARAM SETS
filename    = 'Best_Fitted_Param_Sets_77_MOD_kc2_rt_020b.csv';
par_vals    = csvread(filename,0,0);
param_sets  = par_vals(:,2:end)';


% Full medium condition
X0(strcmp(STATE_names,{'IGF'})) = 13;
X0(strcmp(STATE_names,{'HRG'})) = 1;

%% 
% simulation time frame (Q-stimulation + Drug response)

QTime = param_sets((strcmp(PARAM_name,'IGF_on_time')),1);
QTime = param_sets((strcmp(PARAM_name,'HRG_on_time')),1);

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


% load drug lists
inhibitors  = readtable('model_target_drug_list.xlsx','ReadVariableNames',true);
drugs       = inhibitors.Drug;
drugON      = inhibitors.DrugON;
dose_range  = 10.^[-6 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9];


% main readouts 
readouts_0    = {'phosphoRB','totalCd'};
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
    
        % Subscripts from linear index
        [idx1,idx2,idx3]    = ind2sub([n1d,n2d,n3d],masterIDX);
        
        P0  = param_sets(:,idx3);
        
        % drug treatment (drug, drug ON time)
        dd_idx          = strcmp(PARAM_name,drugs{idx2});
        dd_on_idx       = strcmp(PARAM_name,drugON{idx2});                
        P0(dd_idx)      = dose_range(idx1);
        P0(dd_on_idx)   = t_stim(end);
        
        
        
         % ODE solver (MEX)
        try           
            mex_output      = pi3k_networkmodel(tspan,X0,P0',mex_options);
            variable_values = mex_output.variablevalues;
        catch
            variable_values = ones(length(tspan),length(VARIABLE_name))*NaN
        end
        
        % response profile before stimulation
        mex_starv(:,:,masterIDX)    = variable_values(t_idx_strv,readouts_idx);
        mex_stim(:,:,masterIDX)     = variable_values(t_idx_stim,readouts_idx);
        mex_drug(:,:,masterIDX)     = variable_values(t_idx_drug,readouts_idx);
end

elapsed_time=toc/60; % (about 5 min expected)


%% 
% reshape the parfor-results

[nrow,ncol,~]   = size(mex_starv);
sim_starv       = reshape(mex_starv,[nrow,ncol,n1d,n2d,n3d]);

[nrow,ncol,~]   = size(mex_stim);
sim_stim        = reshape(mex_stim,[nrow,ncol,n1d,n2d,n3d]);

[nrow,ncol,~]   = size(mex_drug);
sim_drug        = reshape(mex_drug,[nrow,ncol,n1d,n2d,n3d]);
% data structure
% d1: time
% d2: variables (readouts)
% d3: dose range (n=15)
% d4: drugs (n = 25)
% d5: models (n=77)





% plot the drug response 

for ii=1:size(sim_drug,2)
    fig = figure('position',[265          95        1233         884]);
    for jj=1:size(sim_drug,4)        
      
        % note: dos-responses at 24 hr
        dat_mat(:,:)    = sim_drug(end,ii,:,jj,:);        
        % normalization
        dat_mat_norm    = dat_mat./repmat(dat_mat(1,:),size(dat_mat,1),1);
        
        subplot(5,5,jj),
        semilogx(dose_range,dat_mat_norm)
        xlabel(drugs{jj}),
        ylabel('normalized')
        figtitle(readouts{ii})
        pbaspect([4 3 1]/4)
        ytickformat('%.1f')
        box off        
    end
    
    % save the figure
    fname = strcat(fullfile(workdir,'Outcome'),'\dose-responses-parental-',readouts{ii},'.jpeg');
    saveas(fig,fname);
    
end

% save data
drug_response.data      = sim_drug;
drug_response.range     = dose_range;
drug_response.drug      = inhibitors;
drug_response.readout   = readouts;
drug_response.time      = tspan_drug;

fname = strcat(fullfile(workdir,'Outcome'),'\dose-responses-data-parental','.mat');
save(fname,'drug_response');
