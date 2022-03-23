function data_adjusted = adjust_resistant_model(sim_data,variable_names)

% Fold change of resistant cells
target_protein(1) = {'totalp21'};
target_protein(2) = {'totalCd'};
target_protein(3) = {'phosphoAkt'};
target_protein(4) = {'phosphoNDRG1'};
target_protein(5) = {'totalCDK4'};
target_protein(6) = {'phosphoS6'};
target_protein(7) = {'phosphoErk'};
target_protein(8) = {'phosphoRB'};


% 'p21(1)','Cd(2)','pAkt(3)','pNDRG1(4)','CDK4(5)','pS6(6)','pERK(7)','pRb(8)'};
% sourced from 'fold change of resistant cell 09012019.xlsx'
% sourced from 'timecourse-pR-parental rp1.xlsx'
fold_change = [7.4;  % (1) p21, averaged value (11.7+8.5+2.44)/3
    2.6; % (2) cyclin D1
    1.9; % (3) pAkt
    1.6; % (4) pNDRG1
    1.5; % (5) CDK4
    1.2; % (6) pS6
    1.4; % (7) pERK
    1.5 % (8) pRb
    ];




for ii = 1:length(target_protein)    
    idx                      = find(strcmp(variable_names,target_protein{ii}));    
    sim_data_targeted(:,idx) = sim_data(:,idx)*fold_change(ii);
end


data_adjusted.data                = sim_data_targeted;
data_adjusted.target_proteins     = target_protein;
data_adjusted.fold_change         = fold_change;



% % re-order of proteins
% % 1) find target readout variables
% target_idx = ismember(variable_names,target_protein);
%
% variable_names = variable_names(target_idx);
%
% % 2) re-order the proteins
% [~, Lib] = ismember(variable_names,target_protein);
% % [rd_vars target_sp(Lib)']
%
% % 3) re-order the fold changes
% fc_re_order = fold_change(Lib);

% 4) extract the data
%sim_data_targeted = sim_data(:,target_idx);
