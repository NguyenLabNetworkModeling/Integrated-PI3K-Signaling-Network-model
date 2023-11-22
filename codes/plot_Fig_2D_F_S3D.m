%% Figure 2D-F (S3D): Computational model (resistant) predicts synergistic drug combinations


clear; clc; close all;

load('workSpace_Fig2DtoF_S3D.mat')

%% Producing the figures

% ICX value
icx_idx     = find(icx_range==1);
drug_name   = drugs(byl_combo(:,2));
colors      = {'Purple','Orange','Aqua'};
readouts    = [2 5 4];

% (2) {'phosphoS6' }
% (4) {'phosphoRB' }
% (5) {'totalCd'   }

title_lab = {'Phospho-S6 (resistant model)','Cyclin D1 (resistant model)','Phospho-RB (resistant model)'};

for kk = 1:length(readouts)

    myvar_id = readouts(kk);


    dat_mat = [];
    dat_mat(:,:)    = real(log2(CDI_score(icx_idx,:,1,:,myvar_id)));
    % data structure
    % d1: icx (4)
    % d2: combo (24)
    % d3: variables (2)
    % d4: model (77)
    % d5: ps6(outputs, n = 2)

    % CDI mean and std
    cdi_se      = nanstd(dat_mat,0,2)./sqrt(sum(~isnan(dat_mat),2));
    cdi_avg     = nanmean(dat_mat,2);

    % sorting
    [cdi_sorted, cdi_idx(1,:)]  = sort(cdi_avg,'ascend');
    drug_name_sorted =drug_name(cdi_idx(1,:));


    xx      = 1:length(cdi_sorted);
    yy      = cdi_sorted;
    yy_se_1 = cdi_se(cdi_idx(1,:));
    yy_se_2 = zeros(1,length(cdi_sorted));
    num_samples_sorted = sum(~isnan(dat_mat(cdi_idx(1,:),:)),2);

    figure('Position',[582   672   719   198]);

    errorbar(xx,yy,yy_se_1,yy_se_2,'.')
    hold on
    bar(yy,'FaceColor',rgb(colors{kk}))
    xticks(1:length(xx))
    xticklabels(drug_name_sorted)
    xtickangle(45)
    ylabel('CDI (synergy, log2)')
    title(title_lab{kk})
    box off

    % save in a table
    tbl_cdi = table(cdi_sorted,yy_se_1,num_samples_sorted);
    tbl_cdi.Properties.RowNames     = drug_name_sorted;
    tbl_cdi.Properties.VariableNames={'Avg','SE','N'};









    %% Drug effect



    for jj = 1:size(R1_effect,2)

        r1_arry = [];
        r2_arry = [];
        r12_arry = [];

        r1_arry(:,1)    = R1_effect(icx_idx,jj,1,:);
        r2_arry(:,1)    = R2_effect(icx_idx,jj,1,:);
        r12_arry(:,1)   = R12_effect(icx_idx,jj,1,:);

        % remove NaN
        r1_arry     = r1_arry(~isnan(r1_arry));
        r2_arry     = r2_arry(~isnan(r2_arry));
        r12_arry    = r12_arry(~isnan(r12_arry));

        % log 10 transformation
        r1_avg      = log10(mean(r1_arry));
        r2_avg      = log10(mean(r2_arry));
        r12_avg     = log10(mean(r12_arry));

        % log 10 transformation
        r1_se       = log10(nanstd(r1_arry))/sqrt(length(r1_arry));
        r2_se       = log10(nanstd(r2_arry))/sqrt(length(r2_arry));
        r12_se      = log10(nanstd(r12_arry))/sqrt(length(r12_arry));

        %         % t-test
        %         [hh1(1,jj),pv1(1,jj)]=ttest2(tmp_data1,tmp_data12);
        %         [hh2(1,jj),pv2(1,jj)]=ttest2(tmp_data2,tmp_data12);

        drug_effect_avg(jj,1,1)    = r1_avg;
        drug_effect_avg(jj,2,1)    = r2_avg;
        drug_effect_avg(jj,3,1)    = r12_avg;

        drug_effect_se(jj,1,1)     = r1_se;
        drug_effect_se(jj,2,1)     = r2_se;
        drug_effect_se(jj,3,1)     = r12_se;
        drug_effect_se(jj,4,1)     = length(r12_arry);

    end



    %% plot drug effect

    figure('Position',[582   672   719   198]);





    data_avg    = drug_effect_avg(:,:,1);
    % d1: single effect 1
    % d2: single effect 2
    % d3: combo effect

    data_se = drug_effect_se(:,1:end-1,1);
    xx      = 1:size(data_avg,1);


    hBar = bar(xx, data_avg(cdi_idx(1,:),:),1);

    for k1 = 1:size(data_avg,2)
        x_array2(k1,:)  = bsxfun(@plus, hBar(1).XData, [hBar(k1).XOffset]');
        ydt(k1,:)       = hBar(k1).YData;
    end

    hold on
    errorbar(x_array2, ydt, data_se(cdi_idx(1,:),:)', '.k')
    hold off

    combo_label = drug_name_sorted(1:length(cdi_avg));

    xticks(1:length(cdi_sorted))
    xticklabels(combo_label)
    xtickangle(45)
    ylabel('Drug effect (log10)')
    title(title_lab{kk})
    legend('Byl719','Drug-X','Both')
    box off


end


