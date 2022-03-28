%% Make a MEX file for the ODE simulation
clear; 
clc;


% Specify the fold where IQM is installed. 
iqmdir = 'C:\IQMtools V1.2.2.2/installIQMtools.m';
run(iqmdir)



%% Load the PI3K network model (a txtbc file)

model   = IQMmodel('pi3k_networkmodel.txtbc');
model   = IQMeditBC(model);



%% Create a MATLAB ODE m-file

IQMcreateODEfile(model,'pi3k_networkmodel_ode')




%% Create a MEX file 

IQMmakeMEXmodel(model,'pi3k_networkmodel')




%% Generate a SBML file

IQMexportSBML(model,'Integrated_PI3K_Network_Model')




%% a test simulation using an ODE file 

tic;
x0s         = pi3k_networkmodel;
[t,x]       = ode15s(@pi3k_networkmodel_ode,0:4000,x0s);

toc_time_1  = toc;
disp(toc_time_1)




%% a test simulation using a MEX file

tic;
mex_out     = pi3k_networkmodel(linspace(0,400,5000));
toc_time_2  = toc;

plot(mex_out.time,mex_out.statevalues)

disp(toc_time_1/toc_time_2);



