# Overview

This page provides supplementary material for the paper "Integrated analysis of the PI3K signalling network uncovers resistance-promoting role of p21WAF1/Cip1 and identifies combination therapies for PIK3CA-driven breast cancer".

The integrated PI3K network model was formulated using ordinary differential equations (ODEs). The model construction and calibration processes were implemented in MATLAB (The MathWorks. Inc. 2019a) and the IQM toolbox (http://www.intiquan.com/intiquan-tools/) was used to compile the IQM file for a MEX file which makes the simulation faster. 

# Run the model
0. Open the project manger file, PI3K_<Model_Manager.m.
1. Specify your root directory where the PI3K_<Model_Manager.m is located.
rootwd = 'YOUR ROOT DIRECTORY';
2. Choose a simulaiton task:
[1] drug_synergy 
[2] simulation 
[3] model_calib 
3. Choose a detailed drug synergy task:
[1] simulate drug responses 
[2] calculate ic50 
[3] simulate icx responses 
[4] calculate CDI 
[5] simulate icx responses (perturbation) 
[6] calculate CDI (perturbation) 
4. Choose a detailed simulation task:
[1] functional role of p21 
[2] ensemble simulation 
[3] model_valid_byl 
5. Choose a model_calib task:
[1] plot fitting results (training data) 

* Unzip BoundedLine.zip and boxplottool.zip to the Packages fold where they are located.

# Contact
If you have any question, contact sungyoung.shin (at) monash.edu
