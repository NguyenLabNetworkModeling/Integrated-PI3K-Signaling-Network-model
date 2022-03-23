%% correaltion analysis of the CDI result

fname_1 = 'drug-synergy-parental-CDI.xlsx';
fname_2 = 'drug-synergy-resistant-CDI.xlsx';

% 1) read sheet names from two files
celltype{1}  = sheetnames(fname_1);
celltype{2}  = sheetnames(fname_2);
% (1) parental
% (2) resistant


for rr_cell = 1:length(celltype) % (cell models)
    % split string (variable proteins)
    delimiter       = string(ones(size(celltype{rr_cell})));
    delimiter(:)    = '-';
    str_sheet       = arrayfun(@strsplit,celltype{rr_cell},delimiter,'UniformOutput',false);
    str_marker      = cellfun(@(x) x{2},str_sheet,'UniformOutput',false);
    str_var          = cellfun(@(x) x{1},str_sheet,'UniformOutput',false);
    
    
    
    % divide the variables to two grops (pRB and Cd)
    ic50_group{1} = str_var(contains(str_marker,'phosphoRB'));
    ic50_group{2}  = str_var(contains(str_marker,'totalCd'));
    cell_lab  = {'parental','resistant'};
    
    
    ic50_sheet{1}  = celltype{rr_cell}(contains(str_marker,'phosphoRB'));
    ic50_sheet{2}  = celltype{rr_cell}(contains(str_marker,'totalCd'));
    
    
    % re-naming
    for ii = 1:length(ic50_group)
        var_lab_tmp = strrep(ic50_group{ii},{'phospho'},{'p'});
        var_lab{ii} = strrep(var_lab_tmp,{'total'},{''});
        % check
        disp([var_lab{ii} ic50_group{ii}  ic50_sheet{ii}])
    end
    % (1) pRB - marker protein
    % (2) cyclin D1 - marker protein
    
    ic50_lab = {'pRB','cyclin D1'};
    
    for jj_ic50 = 1%1:length(ic50_sheet) % (for two ic50 groups, n = 2)
        
        
        % load the sheet data
        for ii_var = 1:length(ic50_sheet{jj_ic50})
            
            tbl = readtable(fname_1,'Sheet',ic50_sheet{jj_ic50}(ii_var));
            
            % sorting and ranking
            [Bb{rr_cell,jj_ic50},rank_array{rr_cell,jj_ic50}(:,ii_var)] = sort(tbl.Row);
            % rank_array:
            % d1: cells (parental, resistant)
            % d2: ic50 (pRB and Cd)
            % d3: readouts (n = 5)
        end
        
        % combinations for plot
        combos = nchoosek(1:length(var_lab{jj_ic50}),2);
        
        
        for ii = [1 10]%:size(combos,1)
            
            combo = combos(ii,:);
            combo_name = var_lab{jj_ic50}(combo);
            
            xx = rank_array{rr_cell,jj_ic50}(:,combo(1));
            yy = rank_array{rr_cell,jj_ic50}(:,combo(2));
            
            % linear regression
            b1 = xx\yy;
            yCalc1 = b1*xx;
            
            rho = corr(xx,yy);
            
           myvar{ii,jj_ic50,rr_cell}.name = combo_name';
           myvar{ii,jj_ic50,rr_cell}.corr = rho;
            
            fig = figure('position',[667   673   387   255]);
            scatter(xx,yy,'filled')
            hold on
            plot(xx,yCalc1)
            
            
            xlabel(strcat(combo_name{1},'(CDI - ranked)'))
            ylabel(strcat(combo_name{2},'(CDI - ranked)'))
            title({strcat('correlation = ',num2str(rho));
                strcat(combo_name{1},' vs. ', combo_name{2},...
                '[',ic50_lab{jj_ic50},'][',cell_lab{rr_cell},']')})
            pbaspect([4 3 1])
            
            % save figure
            fname = strcat(fullfile(workdir,'\Outcome'),'\correlation_CDI_',...
                combo_name{1},' vs ', {' '},combo_name{2},'-[',ic50_lab{jj_ic50},'][',cell_lab{rr_cell},']');
            saveas(fig,fname{1},'jpeg')
            saveas(fig,fname{1},'fig')
            
%             close
            
            % save data
            tbl_ranked_cdi = [array2table(Bb{rr_cell,jj_ic50},'VariableNames',{'drug'}),...
                array2table(rank_array{rr_cell,jj_ic50},'VariableNames',var_lab{jj_ic50})];
            
            fname = strcat(fullfile(workdir,'\Outcome'),'\correlation_CDI_',cell_lab{rr_cell},'.xlsx');
            sheet_nm = strcat(combo_name{1},'_',combo_name{2},'-',ic50_lab{jj_ic50});
            writetable(tbl_ranked_cdi,fname,'WriteVariableNames',true,...
                'Sheet',sheet_nm)
        end
    end
end