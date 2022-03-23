%% Simulaiton manager file 
% choose a task (e.g., simulation, analysis etc)

clear;
clc;
close all;


% specify the directory where this file is located


rootwd = 'YOUR WORKING DIRECTORY';


% Working Folds (shared)
modeldir    = strcat(rootwd,'\Making_ODEs');
traindata   = strcat(rootwd,'\TrainingData');
packdir     = strcat(rootwd,'\Packages');
commdatadir = strcat(rootwd,'\Common');

% add path
addpath(modeldir,genpath(packdir),genpath(traindata),commdatadir);


% Math Model Info
PARAM_name      = deblank(pi3k_networkmodel('Parameters'));
STATE_names     = deblank(pi3k_networkmodel('States'));
VARIABLE_name   = deblank(pi3k_networkmodel('VariableNames'));
P0              = pi3k_networkmodel('parametervalues');
X0              = pi3k_networkmodel; % (initial values)
mex_options.maxnumsteps = 2000;




%% Simulation Jobs
jobs = {
    'drug_synergy';
    'simulation';
    'model_calib';
    'id_test'; % remove this later
    };

disp([num2cell([1:length(jobs)]') jobs])
prompt = 'choose a validation data:  \n';
jobid = input(prompt);


jobcode = jobs{jobid};


%%

Simulation_Task

