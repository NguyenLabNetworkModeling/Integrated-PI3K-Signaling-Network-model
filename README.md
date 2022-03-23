# Overview

This page provides supplementary material for the paper "Integrated analysis of the PI3K signalling network uncovers resistance-promoting role of p21WAF1/Cip1 and identifies combination therapies for PIK3CA-driven breast cancer".

The integrated PI3K network model was formulated using ordinary differential equations (ODEs). The model construction and calibration processes were implemented in MATLAB (The MathWorks. Inc. 2019a) and the IQM toolbox (http://www.intiquan.com/intiquan-tools/) was used to compile the IQM file for a MEX file which makes the simulation faster. 

# Run the model
0. Open the project manger file, PI3K_<Model_Manager.m.
1. Specify your root directory where the PI3K_<Model_Manager.m is located.

  rootwd = 'YOUR ROOT DIRECTORY';

2. Choose a simulaiton job
    - Drug synergy
        a. Simulate drug response
        b. Calculate IC50
        c. Simulate ICX responses
        d. Calculate CDI (synergy score)
        e. Simulate ICX responses (for perturbation analysis)
        f. Simulate CDI (synergy score for perturbatio analysis)        
    - Simulation
        a. Functional analysis of p21
        b. Ensemble simulation
        c. Model validation
    - Model calibration
        a. Run Genetic Algorithm
        b. Plot fitting result
        c. Plot validation result
# Contact
If you have any question, contact sungyoung.shin (at) monash.edu
