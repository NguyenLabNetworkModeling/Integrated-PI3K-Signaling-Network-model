%  Matlab Code for Simulation of the Integrated PI3K Network Model 
%  This is a manager file of the simulaiton project
%  Before running the code, please specficy the path where the this file is located
%  Final updat: 25 Mar 2022
%  Developer: Sungyoung Shin
%  E-mail: sungyoung.shin (a) monash.edu

%%  Manager file

clear;
clc;
close all;

% specify the directory where this file is located
rootwd = 'C:\Users\sshin\OneDrive - Monash University\RESEARCH\___PI3K (p21) proj\_CodeMaster\Matlab\PI3K_Network_Model - GitHub';


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
list_Simulation = {
    'drug_synergy';
    'simulation';
    'model_calib';    
    };

[ methodID ] = readInput( list_Simulation );
Sim_Task_selection = list_Simulation{methodID}; % Selected

Simulation_Task

