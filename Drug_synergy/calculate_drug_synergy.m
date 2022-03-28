%% Calculate Druhg Synergy (CDI)

    if drug_synergy_opt.cell == 1
        load('dose-responses-icx-parental')
    elseif  drug_synergy_opt.cell == 2
        load('dose-responses-icx-resistant')
    end
    sim_drug        = drug_response_icx.data;
    % data structure
    % d1: time
    % d2: icx
    % d3: icx
    % d4: combo
    % d5: readout
    % d6: model
    icx_range       = drug_response_icx.range;
    readouts        = drug_response_icx.readout;
    byl_combo       = drug_response_icx.combo;
    param_sets      = drug_response_icx.param_sets;
    drugs           = drug_response_icx.drug.Drug;


%% CALCULATION OF CDI (SYNERGY)

n1d     = length(icx_range); % icx
n2d     = size(byl_combo,1); % BYL + x (n=24); % combination
n3d     = length(readouts); % readout
n4d     = size(param_sets,2); % model


parfor masterIDX=1:(n1d*n2d*n3d*n4d)
    
    disp(masterIDX)
    
    % Subscripts from linear index
    [idx1,idx2,idx3,idx4]   = ind2sub([n1d,n2d,n3d,n4d],masterIDX);
    % at 24 hr
    cont_R0     = sim_drug(end,1,1,idx2,idx3,idx4);
    % data structure
    % d1: time (500)
    % d2: icx (4)
    % d3: icx (4)
    % d4: combo (24)
    % d5: variables (2)
    % d6: model (77)
    single_R1(masterIDX)    = sim_drug(end,idx1,1,idx2,idx3,idx4)/cont_R0;
    single_R2(masterIDX)    = sim_drug(end,1,idx1,idx2,idx3,idx4)/cont_R0;
    comb_R12(masterIDX)     = sim_drug(end,idx1,idx1,idx2,idx3,idx4)/cont_R0;
    CDI(masterIDX)          = comb_R12(masterIDX)./(single_R1(masterIDX).*single_R2(masterIDX));
    
end

CDI_score = reshape(CDI,[n1d,n2d,n3d,n4d]);
% data structure
% d1: icx (4)
% d2: combo (24)
% d3: variables (2)
% d4: model (77)

% for drug effet [icx, combination,readout, model]
R1_effect=reshape(single_R1,[n1d,n2d,n3d,n4d]);
R2_effect=reshape(single_R2,[n1d,n2d,n3d,n4d]);
R12_effect=reshape(comb_R12,[n1d,n2d,n3d,n4d]);




