clear; clc; close all


load('workSpace_Fig_7D.mat')

    %%  drug - target parameter table

inhibitor_info  = readtable('model_target_drug_list.xlsx','ReadVariableNames',true);
drug_names      = inhibitor_info.Drug;
all_drug_combo=nchoosek(1:length(drug_names),2);
drug_pairs = drug_names(all_drug_combo(ismember(all_drug_combo(:,1),1),:));
drug_pairs(25,:) = {'BYL719','chki'};

% dose leves (ICx) of drug simulated
icx_levels   = [0 1 2];


%% CALCULATION OF CDI (SYNERGY)


n3d     = size(drug_pairs,1); % BYL + x (n=24); % combination
n4d     = size(CV_matrix,4); % model

drug_levels = {
    'ic50'
    'ic75'
    };

[ selected_drug_level ] = readInput( drug_levels );
ic_x = drug_levels{selected_drug_level}; %

switch ic_x

    case 'ic50'
        CV_matrix_icx = CV_matrix([1,2],[1,2],:,:);
    case 'ic75'
        CV_matrix_icx = CV_matrix([1,3],[1,3],:,:);
end

parfor masterIDX=1:(n3d*n4d)
    
    disp(masterIDX)
    
    % Subscripts from linear index
    [idx3,idx4]   = ind2sub([n3d,n4d],masterIDX);
    % at 24 hr
    cont_R0     = CV_matrix_icx(1,1,idx3,idx4);

    drug_byl(masterIDX)    = CV_matrix_icx(2,1,idx3,idx4)/cont_R0;
    drug_x(masterIDX)    = CV_matrix_icx(1,2,idx3,idx4)/cont_R0;
    comb_R12(masterIDX)     = CV_matrix_icx(2,2,idx3,idx4)/cont_R0;
    CDI(masterIDX)          = comb_R12(masterIDX)./(drug_byl(masterIDX).*drug_x(masterIDX));
    
end

CDI_log2 = log2(reshape(CDI,[n3d,n4d]));

% for drug effet [icx, combination,readout, model]
R1_effect=reshape(drug_byl,[n3d,n4d]);
R2_effect=reshape(drug_x,[n3d,n4d]);
R12_effect=reshape(comb_R12,[n3d,n4d]);

cdi_avg = mean(CDI_log2,2);
cdi_se = std(CDI_log2,0,2)/sqrt(size(CDI_log2,2));
[~,ii]=sort(cdi_avg);

drug_name_sorted = drug_pairs(ii,2);

figure('position',[680   769   567   209])
errorbar(cdi_avg(ii),cdi_se(ii),'.')
hold on
bar(cdi_avg(ii))
yline(0)
xticks(1:length(drug_name_sorted))
xticklabels(drug_name_sorted)
ylabel('CDI (log2)')
title(strcat('Cell viability (phenotyptic model) at ',upper(ic_x)))
box off
