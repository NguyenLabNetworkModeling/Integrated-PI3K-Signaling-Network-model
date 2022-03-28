%% Synergy Score plot (CDI)


load('cdi-score_perturbation_50_vm.mat') 


% data rearrange
cdi_score = CDI_score_c{3}; 




%% display options

id_icx          = find(icx_range==1);
id_marker       = 1;
% (1) pRB (default)
% (2) Cd
id_var          = 5;
% (1) {'phosphoErk'}
% (2) {'phosphoS6' }
% (3) {'phosphoS6K'}
% (4) {'phosphoRB' }
% (5) {'totalCd'   }
id_drug         = drugs(byl_combo(:,2));
% note: BYL(1) + X(2)
colors          = {'Purple'};
%'Aqua'


%%

for ii = 1:length(CDI_score_c)
    dat_mat_c(:,:,ii)    = real(log2(CDI_score_c{ii}(id_icx,:,id_marker,:,id_var)));
end


% data structure
% d1: icx (4)
% d2: combo (24)
% d3: markerproteins (2)
% d4: model (77)
% d5: variables (n = 5)


cdi_score_avg_prt(:,:) = nanmean(dat_mat_c,2);

cdi_avg     = nanmean(cdi_score_avg_prt,2);
cdi_std      = nanstd(cdi_score_avg_prt,[],2);

% sorting
[cdi_sorted, cdi_idx]       = sort(cdi_avg,'ascend');
drug_name_sorted            =id_drug(cdi_idx);

cdi_score_sorted(:,ii) =  cdi_sorted;
cdi_name_sorted(:,ii) = drug_name_sorted;



fig_1           = figure;
fig_1.Position  = [410   764   941   214];

xx      = 1:length(cdi_sorted);
yy      = cdi_sorted;
yy_se_1 = cdi_std(cdi_idx);
yy_se_2 = zeros(1,length(cdi_sorted));

errorbar(xx,yy,yy_se_1,yy_se_2,'.')
hold on
bar(yy,'FaceColor',rgb(colors{1}))

xticks(1:length(xx))
xticklabels(drug_name_sorted)
xtickangle(45)
ylabel('CDI (synergy, log2)')
title(strcat(my_variables{id_var},'-[',markerproteins{1},']'))
box off
hold off


% save in a table
tbl_cdi = table(cdi_sorted,yy_se_1);
tbl_cdi.Properties.RowNames     = drug_name_sorted;
tbl_cdi.Properties.VariableNames={'Avg','SE'};


% save the figure
fname = strcat(fullfile(workdir,'Outcome'),'\drug-synergy-parental-perturbation_CDI-',my_variables{id_var});
saveas(fig_1,fname,'jpeg');
saveas(fig_1,fname,'fig');



% save the figure
fname = strcat(fullfile(workdir,'Outcome'),'\drug-synergy-parental-perturbation-CDI','.xlsx');
writetable(tbl_cdi,fname,'WriteRowNames',true,'Sheet',strcat(my_variables{id_var},'-',markerproteins{id_marker},'-ptr'))





% 
% figure('Position',[410   764   941   214])
% 
% %
% icx_id     = find(icx_range==1);
% marker_id = 1;
% var_id    = 4;
% % (1) {'phosphoErk'}
% % (2) {'phosphoS6' }
% % (3) {'phosphoS6K'}
% % (4) {'phosphoRB' }
% % (5) {'totalCd'   }
% 
% 
% drug_name   = drugs(byl_combo(:,2));
% colors      = {'Aqua','Purple'};
% 
% 
% disp(strcat(' ==> ',my_variables{var_id},': selected for plot'));
% 
% 
% % data rearrange
% 
% dat_mat = [];
% dat_mat(:,:,:)    = real(log2(CDI_score(icx_id,:,marker_id,:,var_id,:)));
% 
% % data structure
% % d1: icx (4)
% % d2: combo (24)
% % d3: markerproteins (2)
% % d4: model (77)
% % d5: variables (n = 5)
% % d6: perturbation
% 
% dat_mat_avg = nanmean(dat_mat,3);
% dat_mat_std = nanstd(dat_mat,[],3);
% 
% 
% HeatMap(dat_mat_avg)
% 
% size(dat_mat_avg)
% % CDI mean and std
% cdi_avg     = nanmean(dat_mat_avg,2);
% cdi_se      = nanstd(dat_mat_avg,0,2)./sqrt(sum(~isnan(dat_mat_avg),2));
% 
% 
% % sorting
% [cdi_sorted, cdi_idx]  = sort(cdi_avg,'ascend');
% drug_name_sorted            =drug_name(cdi_idx);
% 
% 
% fig_1   = figure(1);
% 
% xx      = 1:length(cdi_sorted);
% yy      = cdi_sorted;
% yy_se_1 = cdi_se(cdi_idx);
% yy_se_2 = zeros(1,length(cdi_sorted));
% num_samples_sorted = sum(~isnan(dat_mat(cdi_idx,:)),2);
% 
% errorbar(xx,yy,yy_se_1,yy_se_2,'.')
% hold on
% bar(yy,'FaceColor',rgb(colors{1}))
% xticks(1:length(xx))
% xticklabels(drug_name_sorted)
% xtickangle(45)
% ylabel('CDI (synergy, log2)')
% title(strcat(my_variables{var_id},'-[',markerproteins{1},']'))
% box off
%
%     % save in a table
%     tbl_cdi = table(cdi_sorted,yy_se_1,num_samples_sorted);
%     tbl_cdi.Properties.RowNames     = drug_name_sorted;
%     tbl_cdi.Properties.VariableNames={'Avg','SE','N'};
%
%     if DS.cell == 1
%
%         % data
%         fname = strcat(fullfile(workdir,'Outcome'),'\drug-synergy-parental-CDI','.xlsx');
%         writetable(tbl_cdi,fname,'WriteRowNames',true,'Sheet',strcat(my_variables{var_id},'-',markerproteins{ii}))
%
%     elseif  DS.cell == 2
%
%         % save data
%         fname = strcat(fullfile(workdir,'Outcome'),'\drug-synergy-resistant-CDI','.xlsx');
%         writetable(tbl_cdi,fname,'WriteRowNames',true,'Sheet',strcat(my_variables{var_id},'-',markerproteins{ii}))
%     end
%
% end
%
% if DS.cell == 1
%
%     % save the figure
%     fname = strcat(fullfile(workdir,'Outcome'),'\drug-synergy-parental-CDI-',my_variables{var_id});
%     saveas(fig_1,fname,'jpeg');
%     saveas(fig_1,fname,'fig');
%
% elseif  DS.cell == 2
%
%     % save the figure
%     fname = strcat(fullfile(workdir,'Outcome'),'\drug-synergy-resistant-CDI-',my_variables{var_id});
%     saveas(fig_1,fname,'jpeg');
%     saveas(fig_1,fname,'fig');
%
% end
%
%
%
% %% Drug effect
%
%
% for ii = 1:size(R1_effect,3)
%     for jj = 1:size(R1_effect,2)
%
%         r1_arry = [];
%         r2_arry = [];
%         r12_arry = [];
%
%         r1_arry(:,1)    = R1_effect(icx_id,jj,ii,:);
%         r2_arry(:,1)    = R2_effect(icx_id,jj,ii,:);
%         r12_arry(:,1)   = R12_effect(icx_id,jj,ii,:);
%
%         % remove NaN
%         r1_arry     = r1_arry(~isnan(r1_arry));
%         r2_arry     = r2_arry(~isnan(r2_arry));
%         r12_arry    = r12_arry(~isnan(r12_arry));
%
%         % log 10 transformation
%         r1_avg      = log10(mean(r1_arry));
%         r2_avg      = log10(mean(r2_arry));
%         r12_avg     = log10(mean(r12_arry));
%
%         % log 10 transformation
%         r1_se       = log10(nanstd(r1_arry))/sqrt(length(r1_arry));
%         r2_se       = log10(nanstd(r2_arry))/sqrt(length(r2_arry));
%         r12_se      = log10(nanstd(r12_arry))/sqrt(length(r12_arry));
%
%         %         % t-test
%         %         [hh1(ii,jj),pv1(ii,jj)]=ttest2(tmp_data1,tmp_data12);
%         %         [hh2(ii,jj),pv2(ii,jj)]=ttest2(tmp_data2,tmp_data12);
%
%         drug_effect_avg(jj,1,ii)    = r1_avg;
%         drug_effect_avg(jj,2,ii)    = r2_avg;
%         drug_effect_avg(jj,3,ii)    = r12_avg;
%
%         drug_effect_se(jj,1,ii)     = r1_se;
%         drug_effect_se(jj,2,ii)     = r2_se;
%         drug_effect_se(jj,3,ii)     = r12_se;
%         drug_effect_se(jj,4,ii)     = length(r12_arry);
%
%     end
% end
%
%
%
% %% plot drug effect
%
% fig_2 = figure('Position',[410   764   941   214]);
%
%
% for ii=1:size(drug_effect_se,3)
%
%
%     data_avg    = drug_effect_avg(:,:,ii);
%     % d1: single effect 1
%     % d2: single effect 2
%     % d3: combo effect
%
%     data_se = drug_effect_se(:,1:end-1,ii);
%     xx      = 1:size(data_avg,1);
%
%
%     subplot(1,2,ii),
%     hBar = bar(xx, data_avg(cdi_idx(ii,:),:),1);
%
%     for k1 = 1:size(data_avg,2)
%         x_array2(k1,:)  = bsxfun(@plus, hBar(1).XData, [hBar(k1).XOffset]');
%         ydt(k1,:)       = hBar(k1).YData;
%     end
%
%     hold on
%     errorbar(x_array2, ydt, data_se(cdi_idx(ii,:),:)', '.k')
%     hold off
%
%     combo_label = drug_name_sorted(1:length(cdi_avg));
%
%     xticks(1:length(cdi_sorted))
%     xticklabels(combo_label)
%     xtickangle(45)
%     ylabel('Drug effect (log10)')
%     title(strcat(my_variables{var_id},'-[',markerproteins{ii},']'))
%     legend('Byl719','Drug-X','Both')
%     box off
%
% end
%
% if DS.cell == 1
%     % save the figure
%     fname = strcat(fullfile(workdir,'Outcome'),'\drug-synergy-parental-drug_effect-',my_variables{var_id});
%     saveas(fig_2,fname,'jpeg');
%     saveas(fig_2,fname,'fig');
%
%
% elseif DS.cell == 2
%     % save the figure
%     fname = strcat(fullfile(workdir,'Outcome'),'\drug-synergy-resistant-drug_effect-',my_variables{var_id});
%     saveas(fig_2,fname,'jpeg');
%     saveas(fig_2,fname,'fig');
% end
%
