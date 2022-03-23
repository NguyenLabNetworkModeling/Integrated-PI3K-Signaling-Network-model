%% plot ICX-dose response plot
%% save the simulation data

% data structure (sim_drug)
% d1: time
% d2: variables (pS6 and pS6K, ...)
% d3: icx (n = 4)
% d4: icx (n = 4)
% d5: combo (n = 24)
% d6: markerproteins (n = 2)
% d7: model (n = 77)


for ii=1:size(sim_drug,6) % (for markerproteins, n=2)
    
    for kk = 1:size(sim_drug,2) % (for variables such as pS6 and pS6K,...)
            
        fig = figure;
            
        % at steady date (t = 24h)
        % response to BYL in co-treated with other drug
        dat_mat_3d(:,:,:) = sim_drug(end,kk,:,end,:,ii,:);
        % d1: icx (n = 4)
        % d2: combo (n = 24)
        % d3: model (n = 77)
        for jj = 1:size(dat_mat_3d,2) % (all combos)
            
            % note: dos-responses at 24 hr
            dat_mat(:,:)    = dat_mat_3d(:,jj,:);
            % normalization
            drug_comb_idx   = byl_combo(jj,:);
            dat_mat = dat_mat./repmat(dat_mat(1,:),size(dat_mat,1),1);
            
            subplot(5,5,jj),
            semilogy(icx_range,dat_mat)
            xlabel(strcat(drugs{drug_comb_idx(1)},'(IC50)')),
            ylabel(my_variables{ii})
            ytickformat('%.1f')
            title(strcat(drugs{drug_comb_idx(2)},'(',num2str(sum(~isnan(dat_mat(1,:)))),')')),
            pbaspect([4 3 1])
            box off
        end
        
        % save the figure
        figtitle(strcat(my_variables{kk},'-',markerproteins{ii}))
        fname = strcat(fullfile(workdir,'Outcome'),'\dose-responses-parental-icx-',my_variables{kk},'-',markerproteins{ii},'.jpeg');
        saveas(fig,fname);
    end
end


%%
% save data
% save data
drug_response_icx_general.data       = sim_drug;
drug_response_icx_general.range      = icx_range;
drug_response_icx_general.drug       = inhibitors;
drug_response_icx_general.markerproteins = markerproteins;
drug_response_icx_general.variables  = my_variables;
drug_response_icx_general.time       = tspan_drug;
drug_response_icx_general.combo      = byl_combo;
drug_response_icx_general.param_sets = param_sets;
drug_response_icx_general.dataStruc  = {'time', 'variables','icx1', 'icx2','combo','markerproteins','model'};

% data structure
% d1: time
% d2: variables (pS6 and pS6K, ...)
% d3: icx (n = 4)
% d4: icx (n = 4)
% d5: combo (n = 24)
% d6: markerproteins (n = 2)
% d7: model (n = 77)