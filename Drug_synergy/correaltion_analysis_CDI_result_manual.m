%% correaltion analysis of the CDI result

nn = 'non-perutrbation';
% 'non-perutrbation'
% 'perturbation'

switch nn

    case 'non-perutrbation'

        fname = {'drug-synergy-parental-CDI.xlsx',
            'drug-synergy-resistant-CDI.xlsx'};

        sheet_names = {'totalCd-phosphoRB',
            'phosphoRB-phosphoRB',
            'phosphoS6K-phosphoRB',
            'phosphoS6-phosphoRB',
            'phosphoErk-phosphoRB'};

        % choose a file name
        fname_id = 2;
        cell_type = {'parental','resistant'};

        % choose sheets
        sheet_id = [1 2];
        % Cd vs RB (2)
        % Cd vs S6 (4)


        sh_name_x = sheet_names{sheet_id(1)};
        sh_name_y = sheet_names{sheet_id(2)};

        tbl_x = readtable(fname{fname_id},'Sheet',sh_name_x);
        tbl_y = readtable(fname{fname_id},'Sheet',sh_name_y);



    case 'perturbation'

        fname = 'drug-synergy-parental-perturbation-CDI-combined.xlsx';

        sheet_names = { 'phosphoS6-phosphoRB',
            'phosphoRB-phosphoRB',
            'totalCd-phosphoRB',
            'phosphoS6-phosphoRB-ptr',
            'phosphoRB-phosphoRB-ptr',
            'totalCd-phosphoRB-ptr' };


        combo = [1 4;
            2 5;
            3 6];
        % no-prt vs prt (pS6)
        % no-prt vs prt (pRB)
        % no-prt vs prt (Cd)



        % choose sheets (choose a combination)
        sheet_id = combo(3,:);

        sh_name_x = sheet_names{sheet_id(1)};
        sh_name_y = sheet_names{sheet_id(2)};

        tbl_x = readtable(fname,'Sheet',sh_name_x);
        tbl_y = readtable(fname,'Sheet',sh_name_y);

end



[lab_x, xx] = sort(tbl_x.Row);
[lab_x, yy] = sort(tbl_y.Row);

str_x = strsplit(sh_name_x,'-');
str_y = strsplit(sh_name_y,'-');


% renaming
var_x = strrep(str_x{1},'phospho','p');
var_x = strrep(var_x,'total','');

var_y = strrep(str_y{1},'phospho','p');
var_y = strrep(var_y,'total','');



% linear regression
b1      = xx\yy;
yCalc1  = b1*xx;

% correlation
rho     = corr(xx,yy);



fig = figure('position',[667   673   387   255]);
scatter(xx,yy,'filled')
hold on
plot(xx,yCalc1)





switch nn

    case 'non-perutrbation'

        xlabel(var_x)
        ylabel(var_y)
        title(strcat(var_x,'-vs-',var_y,'(Correlation = ',num2str(rho),')'))
        pbaspect([4 3 1])

        % save figure
        fname = strcat(fullfile(workdir,'\Outcome'),'\correlation_CDI_robustness_',var_x,'-vs-',var_y);
        saveas(fig,fname,'jpeg')
        saveas(fig,fname,'fig')

    case 'perturbation'

        xlabel(strcat('Ranked CDI (Control)'))
        ylabel(strcat('Rranked CDI (Perturbation)'))
        title(strcat(var_x,'(Correlation = ',num2str(rho),')'))
        pbaspect([4 3 1])

        % save figure
        fname = strcat(fullfile(workdir,'\Outcome'),'\correlation_CDI_perturbation_',var_x);
        saveas(fig,fname,'jpeg')
        saveas(fig,fname,'fig')

end








% % %
% % % %             close
% % %
% % % % save data
% % % tbl_ranked_cdi = [array2table(lab_x,'VariableNames',{'drug'}),...
% % %     array2table([xx yy],'VariableNames',{var_x,var_y})];
% % %
% % % fname = strcat(fullfile(workdir,'\Outcome'),'\correlation_CDI_',cell_type{fname_id},'.xlsx');
% % % sheet_nm = strcat(var_x,'_',var_y);
% % % writetable(tbl_ranked_cdi,fname,'WriteVariableNames',true,...
% % %     'Sheet',sheet_nm)
% % %
% % %
% % %





%
%
%
%
%
% % 1) read sheet names from two files
% celltype{1}  = sheetnames(fname_1);
% celltype{2}  = sheetnames(fname_2);
% % (1) parental
% % (2) resistant
%
%
% for rr_cell = 1:length(celltype) % (cell models)
%     % split string (variable proteins)
%     delimiter       = string(ones(size(celltype{rr_cell})));
%     delimiter(:)    = '-';
%     str_sheet       = arrayfun(@strsplit,celltype{rr_cell},delimiter,'UniformOutput',false);
%     str_marker      = cellfun(@(x) x{2},str_sheet,'UniformOutput',false);
%     str_var          = cellfun(@(x) x{1},str_sheet,'UniformOutput',false);
%
%
%
%     % divide the variables to two grops (pRB and Cd)
%     ic50_group{1} = str_var(contains(str_marker,'phosphoRB'));
%     ic50_group{2}  = str_var(contains(str_marker,'totalCd'));
%     cell_lab  = {'parental','resistant'};
%
%
%     ic50_sheet{1}  = celltype{rr_cell}(contains(str_marker,'phosphoRB'));
%     ic50_sheet{2}  = celltype{rr_cell}(contains(str_marker,'totalCd'));
%
%
%     % re-naming
%     for ii = 1:length(ic50_group)
%         var_lab_tmp = strrep(ic50_group{ii},{'phospho'},{'p'});
%         var_lab{ii} = strrep(var_lab_tmp,{'total'},{''});
%         % check
%         disp([var_lab{ii} ic50_group{ii}  ic50_sheet{ii}])
%     end
%     % (1) pRB - marker protein
%     % (2) cyclin D1 - marker protein
%
%     ic50_lab = {'pRB','cyclin D1'};
%
%     for jj_ic50 = 1%1:length(ic50_sheet) % (for two ic50 groups, n = 2)
%
%
%         % load the sheet data
%         for ii_var = 1:length(ic50_sheet{jj_ic50})
%
%             tbl = readtable(fname_1,'Sheet',ic50_sheet{jj_ic50}(ii_var));
%
%             % sorting and ranking
%             [Bb{rr_cell,jj_ic50},rank_array{rr_cell,jj_ic50}(:,ii_var)] = sort(tbl.Row);
%             % rank_array:
%             % d1: cells (parental, resistant)
%             % d2: ic50 (pRB and Cd)
%             % d3: readouts (n = 5)
%         end
%
%         % combinations for plot
%         combos = nchoosek(1:length(var_lab{jj_ic50}),2);
%
%
%         for ii = [1 10]%:size(combos,1)
%
%             combo = combos(ii,:);
%             combo_name = var_lab{jj_ic50}(combo);
%
%             xx = rank_array{rr_cell,jj_ic50}(:,combo(1));
%             yy = rank_array{rr_cell,jj_ic50}(:,combo(2));
%
%             % linear regression
%             b1 = xx\yy;
%             yCalc1 = b1*xx;
%
%             rho = corr(xx,yy);
%
%             myvar{ii,jj_ic50,rr_cell}.name = combo_name';
%             myvar{ii,jj_ic50,rr_cell}.corr = rho;
%
%
%         end
%     end
% end