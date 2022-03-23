%% Synergy Score plot (CDI)

figure('Position',[410   764   941   214])

% ICX value
icx_idx     = find(icx_range==1);
drug_name   = drugs(byl_combo(:,2));
colors      = {'Aqua','Purple'};


for ii =1:size(CDI_score,3)
    
    dat_mat = [];
    dat_mat(:,:)    = real(log2(CDI_score(icx_idx,:,ii,:)));
    % data structure
    % d1: icx (4)
    % d2: combo (24)
    % d3: variables (2)
    % d4: model (77)
    
    
    % CDI mean and std
    cdi_se      = nanstd(dat_mat,0,2)./sqrt(sum(~isnan(dat_mat),2));
    cdi_avg     = nanmean(dat_mat,2);
    
    % sorting
    [cdi_sorted, cdi_idx(ii,:)]  = sort(cdi_avg,'ascend');
    drug_name_sorted            =drug_name(cdi_idx(ii,:));
    
    
    fig_1   = figure(1);
    
    xx      = 1:length(cdi_sorted);
    yy      = cdi_sorted;
    yy_se_1 = cdi_se(cdi_idx(ii,:));
    yy_se_2 = zeros(1,length(cdi_sorted));
    
    subplot(1,2,ii),errorbar(xx,yy,yy_se_1,yy_se_2,'.')
    hold on
    bar(yy,'FaceColor',rgb(colors{ii}))
    xticks(1:length(xx))
    xticklabels(drug_name_sorted)
    xtickangle(45)
    ylabel('CDI (synergy, log2)')
    title(readouts{ii})
    box off
    
    
    
    
    % save in a table
    tbl_cdi = table(cdi_sorted,yy_se_1,sum(~isnan(dat_mat),2));
    tbl_cdi.Properties.RowNames     = drug_name_sorted;
    tbl_cdi.Properties.VariableNames={'Avg','SE','N'};
    
    
    
    if DS_option.cell == 1
        
        % save the figure
        fname = strcat(fullfile(workdir,'Outcome'),'\drug-synergy-parental-CDI-',readouts{ii},'.jpeg');
        saveas(fig_1,fname);
        
        % save the figure
        fname = strcat(fullfile(workdir,'Outcome'),'\drug-synergy-parental-CDI','.xlsx');
        writetable(tbl_cdi,fname,'WriteRowNames',true,'Sheet',readouts{ii})
        
    elseif  DS_option.cell == 2
        
        % save the figure
        fname = strcat(fullfile(workdir,'Outcome'),'\drug-synergy-resistant-CDI-',readouts{ii},'.jpeg');
        saveas(fig_1,fname);
        
        % save the figure
        fname = strcat(fullfile(workdir,'Outcome'),'\drug-synergy-resistant-CDI','.xlsx');
        writetable(tbl_cdi,fname,'WriteRowNames',true,'Sheet',readouts{ii})
    end
       
    
end





%% Drug effect


for ii = 1:size(R1_effect,3)
    for jj = 1:size(R1_effect,2)
        
        r1_arry = [];
        r2_arry = [];
        r12_arry = [];
        
        r1_arry(:,1)    = R1_effect(icx_idx,jj,ii,:);
        r2_arry(:,1)    = R2_effect(icx_idx,jj,ii,:);
        r12_arry(:,1)   = R12_effect(icx_idx,jj,ii,:);
        
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
        %         [hh1(ii,jj),pv1(ii,jj)]=ttest2(tmp_data1,tmp_data12);
        %         [hh2(ii,jj),pv2(ii,jj)]=ttest2(tmp_data2,tmp_data12);
        
        drug_effect_avg(jj,1,ii)    = r1_avg;
        drug_effect_avg(jj,2,ii)    = r2_avg;
        drug_effect_avg(jj,3,ii)    = r12_avg;
        
        drug_effect_se(jj,1,ii)     = r1_se;
        drug_effect_se(jj,2,ii)     = r2_se;
        drug_effect_se(jj,3,ii)     = r12_se;
        drug_effect_se(jj,4,ii)     = length(r12_arry);
        
    end
end



%% plot drug effect

fig_2 = figure('Position',[410   764   941   214]);


for ii=1:size(drug_effect_se,3)
    
    
    data_avg    = drug_effect_avg(:,:,ii);
    % d1: single effect 1
    % d2: single effect 2
    % d3: combo effect
    
    data_se = drug_effect_se(:,1:end-1,ii);
    xx      = 1:size(data_avg,1);
    
    
    subplot(1,2,ii),
    hBar = bar(xx, data_avg(cdi_idx(ii,:),:),1);
    
    for k1 = 1:size(data_avg,2)
        x_array2(k1,:)  = bsxfun(@plus, hBar(1).XData, [hBar(k1).XOffset]');
        ydt(k1,:)       = hBar(k1).YData;
    end
    
    hold on
    errorbar(x_array2, ydt, data_se(cdi_idx(ii,:),:)', '.k')
    hold off
    
    combo_label = drug_name_sorted(1:length(cdi_avg));
    
    xticks(1:length(cdi_sorted))
    xticklabels(combo_label)
    xtickangle(45)
    ylabel('Drug effect (log10)')
    title(readouts{ii})
    legend('Byl719','Drug-X','Both')
    box off
    
    
    if DS_option.cell == 1
        % save the figure
        fname = strcat(fullfile(workdir,'Outcome'),'\drug-synergy-parental-drug_effect-',readouts{ii},'.jpeg');
        saveas(fig_2,fname);
        
        
    elseif DS_option.cell == 2
        % save the figure
        fname = strcat(fullfile(workdir,'Outcome'),'\drug-synergy-resistant-drug_effect-',readouts{ii},'.jpeg');
        saveas(fig_2,fname);
        
    end
    
end


