%% RUN GENETIC ALGORITHMS
% Update: 13 Feb 2022
% - Data_Format_VER_2
% - Common file


%% Load Calibration Data
Data_Format_VER_2


%% Initial Guess values for GA
paramnames      = EstimData.model.paramnames;
% choose the param indexes to be estimated
% or provide the param names directly
% step 1: specify the parameters to be estimated
targetparam_1   = paramnames(1:140);
targetparam_2   = paramnames(ismember(paramnames,{'Ki_rt_004','Ki_rt_010'}));
targetparam     = unique([targetparam_1;targetparam_2]);
target_param_index = find(ismember(paramnames,targetparam));

% step 2: is there an exising parameter values
use_existing_param = 1;
if use_existing_param == 1
    best_fit_param  = readmatrix('best_fitted_params_old.csv');
    ga_param_p0     = best_fit_param(11,2:end);
else
    ga_param_p0     = EstimData.model.bestfit;
end
ga_param_p1 = ga_param_p0(target_param_index);

% Step 3: a random parameter values used for calibration?
use_random_val = 1;
% 0: using a given set
% 1: using a randome set
if use_random_val == 0    
    % LOG-10 TRANSFORMATION
    ga_param_p1_log10(1,:)  = log10(ga_param_p1);    
elseif use_random_val == 1
    % RANDOMLY GENERATED PARAMETER VALUE
    ub  = 3; % upper boundary
    lb  = -3; % lower bunder
    ga_param_p1_log10(1,:) = round((ub-(ub-lb)*rand(1,length(targetparam))),3);
end


%% Genetic Algorithm
% PARAMETERIZED OBJECT FUNCTION
objfun  = @(X0) GA_User_Code(X0,EstimData,target_param_index);
% X0: initial guess values/inviduals of GA
% UPPER AND LOWER BOUNDARY
LB      = ones(1,length(target_param_index))*-3;
UB      = ones(1,length(target_param_index))*3;

% GA OPTIONS
options_ga  = gaoptimset(...
    'PlotFcns',{@gaplotbestf,@gaplotbestindiv},...
    'InitialPopulation',ga_param_p1_log10,...
    'Generations',10,...
    'PopulationSize',200,...
    'Display','iter',...
    'UseParallel',true,...
    'FitnessLimit',0.02,...
    'MutationFcn',{@mutationadaptfeasible,0.3}); %default is 0.01


% CALL GA FUNCTION
tic
[x1,fval1,exitflag,output,population,scores] = ...
    ga(objfun,length(ga_param_p1),[],[],[],[],LB,UB,[],options_ga);
toc


% UPDATE THE BEST-FITTED PARAMS
ga_param_p0(target_param_index) = 10.^x1;
EstimData.model.bestfit         = ga_param_p0;

% RPEAT THE SETPS

%% SAVE the Fitting Results
% paramset = [paramset;[fval1 new_param]] ;
% save('paramset_tuned_no_constraint.txt','paramset','-ascii')

%% Plot Fitting Results
EstimData.model.maxnumsteps     = 1000;
[obj_val,EstimData]     = GA_User_Code([],EstimData,[]);
new_param               = reshape(EstimData.model.paramvals,1,length(EstimData.model.paramvals));

%
for ii=1:length(EstimData.sim.resampled)
    
    sim_dat     = EstimData.sim.resampled{ii}; % sim data
    exp_dat     = EstimData.expt.data{ii}; % exp data
    
    figure(ii)
    
    if strcmp(EstimData.expt.type{ii},'dose')
        dose_range  = EstimData.expt.dose{ii};
        proteins    = EstimData.expt.names{ii};
        x_lab       = EstimData.expt.type{ii}{1};
        ligand      = EstimData.expt.ligand{ii}{1};
        
        for jj = 1:length(sim_dat)
            subplot(1,length(sim_dat),jj),plot(dose_range,[sim_dat{jj}/max(sim_dat{jj}) exp_dat{jj}/max(exp_dat{jj})])
            ylabel(proteins{jj});
            xlabel(x_lab)
            pbaspect([4 3 1])
            box off
        end
        
    elseif strcmp(EstimData.expt.type{ii},'time')
        
        time_interval   = EstimData.expt.time{ii};
        proteins        = EstimData.expt.names{ii};
        x_lab           = EstimData.expt.type{ii}{1};
        
        for jj = 1:length(sim_dat)
            subplot(1,length(sim_dat),jj),plot(time_interval,[sim_dat{jj}/max(sim_dat{jj}) exp_dat{jj}/max(exp_dat{jj})])
            ylabel(proteins{jj});
            xlabel(x_lab)
            pbaspect([4 3 1])
            box off
        end
    end
    
    title_str = strcat('Stimulation (ligand):',{' '},ligand);
    figtitle(title_str{1})
    legend('Simulation','Experiment')
    
end