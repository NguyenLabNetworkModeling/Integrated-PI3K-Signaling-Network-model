function x_b0 = Customization_Resistant_Model(x_b0,state_names)

% Fold change of resistant cells
target_sp{1} = {'p_p21','p21','K4Da_p21','K2Ea_p21'};
target_sp{2} = {'Cd','K4D','K4Da','K4Da_p21'};
target_sp{3} = {'pAkt'};
target_sp{4} = {'pNDRG1'};
target_sp{5} = {'CDK4','K4D','K4Da','K4Da_p21'};
target_sp{6} = {'pS6'};
target_sp{7} = {'pErk'};
target_sp{8} = {'pRb','ppRB'};

fold_change = [7.4;  % (1) p21, averaged value (11.7+8.5+2.44)/3
    2.6; % (2) cyclin D1
    1.9; % (3) pAkt
    1.6; % (4) pNDRG1
    1.5; % (5) CDK4
    1.2; % (6) pS6
    1.4; % (7) pERK
    1.5 % (8) pRb
    ];


% reflecting the fold chage to the initial values
for rr = 1:length(target_sp)
    tmp_idx = find(ismember(state_names,target_sp{rr}));
    x_b0(tmp_idx) =  x_b0(tmp_idx) * fold_change(rr);
end