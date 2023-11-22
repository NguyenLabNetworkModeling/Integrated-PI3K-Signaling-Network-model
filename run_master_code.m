%% Supplementary Information for "Integrated analyses prioritize therapies for PIK3CA-mutant breast cancer and reveal a pro-survival role for p21 in drug resistance"
%% Hon Yan Kelvin Yip1,2, Sung-Young Shin1,2, Annabel Chee1,3, Ching-Seng Ang4, Fernando Rossello5, Lee Hwa Wong1, Lan K. Nguyen1,*, and Antonella Papa1,6,* 
%% 1Cancer Program, Monash Biomedicine Discovery Institute and Department of Biochemistry and Molecular Biology, Monash University, Melbourne, Victoria 3800, Australia.
%% 4Bio21 Mass Spectrometry and Proteomics Facility, The University of Melbourne, Parkville, VIC 3010, Australia.
%% 5 Murdoch Children's Research Institute, Melbourne, Victoria, Australia.
%% 2These authors contributed equally.
%% 3Present address: Centre for Muscle Research, Department of Anatomy and Physiology, The University of Melbourne, Melbourne, VIC 3010, Australia
%% 6Lead contact
%% *Corresponding author: lan.k.nguyen@monash.edu (L.K.N), antonella.papa@monash.edu (A.P.)


clear;  close all; clc;


% Include file dependencies
addpath(genpath('./data'));
addpath(genpath('./codes'));
addpath(genpath('./output'));
addpath(genpath('./results'));
rootwd = pwd;

plots = {
    'Figure 1B: Comparison of model predictions and experimental data'
    'Figure S1D: Model validation using independent experimental data'
    'Figure 1E: Model prediction of signaling response to BYL719'
    'Figure 2A-C (S3C): Computational model (parental) predicts synergistic drug combinations'
    'Figure 2D-F (S3D): Computational model (resistant) predicts synergistic drug combinations'
    'Figure 2G: Simulation of phospho-AKT, phospho-S6, and cyclin D1 levels to BYL719 and GSK2334470'
    'Figure 4AB: Model predictions assessing inter-dependency between p21 levels'
    'Figure 7D: Model simulations (the phenotypic model) of drug synergism for 25 drug pairings co-targeting PI3K'    
    };


[ plotID ] = readInput( plots );
plotNo = plots{plotID}; % Selected

switch plotNo

    case 'Figure 1B: Comparison of model predictions and experimental data'
        plot_Figure_1B

    case 'Figure 1E: Model prediction of signaling response to BYL719'
        plot_Figure_1E

    case 'Figure 2A-C (S3C): Computational model (parental) predicts synergistic drug combinations'
        plot_Fig_2A_C_S3C

    case 'Figure 2D-F (S3D): Computational model (resistant) predicts synergistic drug combinations'
        plot_Fig_2D_F_S3D


    case 'Figure 2G: Simulation of phospho-AKT, phospho-S6, and cyclin D1 levels to BYL719 and GSK2334470'
        plot_Figure_2G

    case 'Figure 4AB: Model predictions assessing inter-dependency between p21 levels'
        plot_Figure_4AB

    case 'Figure S1D: Model validation using independent experimental data'
        plot_Figure_S1D

    case 'Figure 7D: Model simulations (the phenotypic model) of drug synergism for 25 drug pairings co-targeting PI3K'
        plot_Figure_7D

end








