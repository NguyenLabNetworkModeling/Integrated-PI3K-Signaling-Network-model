%% Calculate Druhg Synergy (CDI)


load(strcat('icx-parental_perturbation_',num2str(ptr_size)))
    

sim_drug        = drug_response_icx_perturbation.data;
% data structure
% d1: time (n = 5)
% d2: variable (n=5)
% d3: icx (n = 4)
% d4: icx (n = 4)
% d5: combo (n = 24)
% d6: readout (n = 2)
% d7: model (n = 77)
% d8: perturbation (n = 50)

icx_range       = drug_response_icx_general.range;
markerproteins  = drug_response_icx_general.markerproteins;
byl_combo       = drug_response_icx_general.combo;
param_sets      = drug_response_icx_general.param_sets;
drugs           = drug_response_icx_general.drug.Drug;
my_variables    = drug_response_icx_general.variables;





%% CALCULATION OF CDI (SYNERGY)

n1d     = length(icx_range); % icx (n = 4)
n2d     = size(byl_combo,1); % BYL + x (n=24); % combination
n3d     = length(markerproteins); % (markerproteins for ic50, n = 2)
n4d     = size(param_sets,2); % model (n = 77)
n5d     = length(my_variables); % (variables, n = 5)
n6d     = size(sim_drug,8) ; % num of perturbation

parfor masterIDX=1:(n1d*n2d*n3d*n4d*n5d*n6d)
    
    disp(masterIDX)
    
    % Subscripts from linear index
    [idx1,idx2,idx3,idx4,idx5,idx6]   = ind2sub([n1d,n2d,n3d,n4d,n5d,n6d],masterIDX);
    % at 24 hr
    cont_R0     = sim_drug(end,idx5,1,1,idx2,idx3,idx4,idx6);
    % data structure
    % d1: time (500)
    % d2: icx (4)
    % d3: icx (4)
    % d4: combo (24)
    % d5: variables (2)
    % d6: model (77)
    single_R1(masterIDX)    = sim_drug(end,idx5,idx1,1,idx2,idx3,idx4)/cont_R0;
    single_R2(masterIDX)    = sim_drug(end,idx5,1,idx1,idx2,idx3,idx4)/cont_R0;
    comb_R12(masterIDX)     = sim_drug(end,idx5,idx1,idx1,idx2,idx3,idx4)/cont_R0;
    CDI(masterIDX)          = comb_R12(masterIDX)./(single_R1(masterIDX).*single_R2(masterIDX));
    
end

CDI_score = reshape(CDI,[n1d,n2d,n3d,n4d,n5d,n6d]);
% data structure
% d1: icx (4)
% d2: combo (24)
% d3: markerproteins (2)
% d4: model (77)
% d5: variables (n = 5)
% d6: perturbation


% for drug effet [icx, combination,readout, model]
R1_effect=reshape(single_R1,[n1d,n2d,n3d,n4d,n5d,n6d]);
R2_effect=reshape(single_R2,[n1d,n2d,n3d,n4d,n5d,n6d]);
R12_effect=reshape(comb_R12,[n1d,n2d,n3d,n4d,n5d,n6d]);
