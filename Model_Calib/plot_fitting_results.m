%% CLEAR ALL WORKSPACE


Data_Format_VER_2
% data_format_plot_2
% (Insulin dose response data (1 and 10 nM) included)

% paramnames = EstimData.model.paramnames;
% param_vals = EstimData.model.bestfit;


% LOAD THE BEST-FITTED PARAMETER SETS

filename    = 'Best_Fitted_Param_Sets_77_MOD_kc2_rt_020b.csv';
par_vals    = csvread(filename);
param_sets  = par_vals(:,2:end)';
num_samples  = size(param_sets,2);


%paramnames = pi3k_networkmodel('parameters');
% PLOT A PARAMETER LANDSCAPE
% avg     = (mean((log10(param_sets(1:140,:))),2));
% stdev   = (std((log10(param_sets(1:140,:))),0,2));

figure('Position',[297         844        1334         134]),
boxplot(log10(param_sets(1:140,:))','Notch','on')% ,'Labels',paramnames(1:140))
set(gca,'XTickLabel',[])
xlabel('Parameter ID')
ylabel('log10')
title('Parameter landscape')
box off

figure('Position',[297         844        1334         134]),
boxplot(log10(param_sets(1:140,:))','PlotStyle','compact')
set(gca,'XTickLabel',[])
xlabel('Parameter ID')
ylabel('log10')
title('Parameter landscape')
box off






%% reproduce fitting results of all parameter sets


for jj=1:size(param_sets,2) % (for all models)
    
    disp(jj)
    
    % udpate the best-fitted params
    EstimData.model.bestfit     = param_sets(:,jj);
    [~,EstimData]               = GA_User_Code([],EstimData,[]);
    
    
    for ii=1:length(EstimData.sim.resampled) % (experiments)
        for kk=1:length(EstimData.sim.resampled{ii}) % (exp-data)
            resampled_data{jj}{ii}{kk} = EstimData.sim.resampled{ii}{kk};
            
            gram_calib_dat{ii}{kk}{jj}(1,:) = resampled_data{jj}{ii}{kk}/max(resampled_data{jj}{ii}{kk});
            gram_calib_type{jj}     = 'sim';
            % data structure
            % d1: model
            % d2: training set
            % d3: data
            
            gram_calib_dat{ii}{kk}{size(param_sets,2)+1}(1,:)   = ...
                EstimData.expt.data{ii}{kk}/max(EstimData.expt.data{ii}{kk});
            gram_calib_type{size(param_sets,2)+1}   = 'exp';
            
            gram_calib_dat{ii}{kk}{size(param_sets,2)+2}(1,:)   = ...
                EstimData.expt.data{ii}{kk}/max(EstimData.expt.data{ii}{kk});
            gram_calib_type{size(param_sets,2)+2}   = 'exp';
            
            
        end
    end
end



%% calculate mean and std of re-sampled simulated data

for ii=1:length(EstimData.sim.resampled) % experiments
    
    for kk=1:length(EstimData.sim.resampled{ii}) % exp-data
        
        dat_sim_norm = [];
        
        for jj=1:size(param_sets,2) % models (n=77)
            % normalized to max
            dat_sim_norm(:,jj)   = resampled_data{jj}{ii}{kk}/max(resampled_data{jj}{ii}{kk});
        end
        
        dat_sim_norm_avg{ii}{kk}           = mean(dat_sim_norm,2);
        dat_sim_norm_std{ii}{kk}           = std(dat_sim_norm,0,2);
        
    end
end




%% plot error bar

% gram variables
gramm_calib.x_variable   = [];
gramm_calib.sim_dat      = [];
gramm_calib.exp_dat      = [];
gramm_calib.readout      = [];
gramm_calib.dose_time    = [];
gramm_calib.ligands      = [];
gramm_calib.experiment   = [];

for ii=1:length(EstimData.sim.resampled) % experiments
    
    % gram variables(intermedate)
    gramm_x_var     = [];
    gramm_sim_dat   = [];
    gramm_exp_dat   = [];
    gram_readout    = []; % readout
    gram_time_dose  = []; % time/dose
    gram_ligands    = [];
    gram_exp_id     = [];
    
    
    exp_dat        = EstimData.expt.data{ii}; % note: not normalized
    sim_dat_avg    = dat_sim_norm_avg{ii};
    sim_dat_std    = dat_sim_norm_std{ii};
    dat_type       = EstimData.expt.type{ii}{1};
    % Lig = EstimData.expt.ligand{ii};
    
    fig = figure(ii);
    fig.Position = [681   714   560   265];
    
    if strcmp(dat_type,'dose')
        
        xx          = EstimData.expt.dose{ii};
        proteins    = EstimData.expt.names{ii};
        proteins    = strrep(proteins,'phospho','p');
        proteins    = strrep(proteins,'total','');
        x_lab       = dat_type;
        ligand      = EstimData.expt.ligand{ii}{1};
        
        tbl_dat         = [];
        for jj = 1:length(sim_dat_avg)
            
            subplot(1,length(sim_dat_avg),jj)
            
            yy_s = sim_dat_avg{jj};
            yy_e = sim_dat_std{jj};
            yy_p = exp_dat{jj}/max(exp_dat{jj});
            
            plotshaded(xx',[yy_s-yy_e yy_s+yy_e]',rgb('blue'))
            hold on
            plot(xx,yy_s,'-ob','LineWidth',1,...
                'MarkerFaceColor',[0 0 1],...
                'MarkerEdgeColor',[0 0 1])
            
            hold on
            plot(xx,yy_p,'-sr','LineWidth',1,...
                'MarkerFaceColor',[1 0 0],...
                'MarkerEdgeColor',[1 0 0])
            
            ylabel(proteins{jj});
            xlabel(x_lab)
            axis([0 inf 0 1.2 ])
            pbaspect([4 3 1])
            box off
            offsetAxes
            
            var_name = (strcat(proteins{jj},  {strcat('_',x_lab),'_Exp','_sim','_std'}));
            tbl_dat = [tbl_dat array2table([xx yy_s yy_e yy_p],...
                'VariableNames',var_name )];
            
            % save the plot data
            f_name = strcat(fullfile(workdir,'Outcome'),'\model_fitting_result.xlsx');
            sh_name = strcat(ligand,'-',dat_type);
            writetable(tbl_dat,f_name,'Sheet',sh_name);
            
            % gramm data
            gramm_x_var    = [gramm_x_var; xx];
            gramm_sim_dat  = [gramm_sim_dat; yy_s];
            gramm_exp_dat  = [gramm_exp_dat; yy_p];
            readout        = cell(size(xx));
            readout(:)     = proteins(jj);
            gram_readout   = [gram_readout;readout]; % readout
            time_dose      = cell(size(xx));
            time_dose(:)   = {x_lab};
            gram_time_dose = [gram_time_dose;time_dose]; % time/dose
            stims          = cell(size(xx));
            stims(:)       = {ligand};
            gram_ligands   = [gram_ligands;stims];
            exp_id          = cell(size(xx));
            exp_id(:)       = {num2str(ii)};
            gram_exp_id    = [gram_exp_id;exp_id];
        end
                
    elseif strcmp(dat_type,'time')
        
        xx          = EstimData.expt.time{ii};
        proteins    = EstimData.expt.names{ii};
        proteins    = strrep(proteins,'phospho','p');
        proteins    = strrep(proteins,'total','');
        x_lab       = dat_type;
        ligand      = EstimData.expt.ligand{ii}{1};
        
        tbl_dat         = [];
        for jj = 1:length(sim_dat_avg)
            
            subplot(1,length(sim_dat_avg),jj),
            
            yy_s = sim_dat_avg{jj};
            yy_e = sim_dat_std{jj};
            yy_p = exp_dat{jj}/max(exp_dat{jj});
            
            plotshaded(xx',[yy_s-yy_e yy_s+yy_e]',rgb('blue'))
            hold on
            plot(xx,yy_s,'-ob','LineWidth',1,...
                'MarkerFaceColor',[0 0 1],...
                'MarkerEdgeColor',[0 0 1])
            
            hold on
            plot(xx,yy_p,'-sr','LineWidth',1,...
                'MarkerFaceColor',[1 0 0],...
                'MarkerEdgeColor',[1 0 0])
            
            ylabel(proteins{jj});
            xlabel(x_lab)
            axis([0 inf 0 1.2 ])
            pbaspect([4 3 1])
            box off
            offsetAxes
            
            var_name = (strcat(proteins{jj},  {strcat('_',x_lab),'_Exp','_sim','_std'}));
            var_name = strrep(var_name,'total','');
            tbl_dat = [tbl_dat array2table([xx yy_s yy_e yy_p],...
                'VariableNames',var_name )];
            
            % save the plot data
            f_name = strcat(fullfile(workdir,'Outcome'),'\model_fitting_result.xlsx');
            sh_name = strcat(ligand,'-',dat_type);
            writetable(tbl_dat,f_name,'Sheet',sh_name);
                        
            % gramm data
            gramm_x_var    = [gramm_x_var; xx];
            gramm_sim_dat  = [gramm_sim_dat; yy_s];
            gramm_exp_dat  = [gramm_exp_dat; yy_p];
            readout        = cell(size(xx));
            readout(:)     = proteins(jj);
            gram_readout   = [gram_readout;readout]; % readout
            time_dose      = cell(size(xx));
            time_dose(:)   = {x_lab};
            gram_time_dose = [gram_time_dose;time_dose]; % time/dose
            stims          = cell(size(xx));
            stims(:)       = {ligand};
            gram_ligands   = [gram_ligands;stims];
            exp_id          = cell(size(xx));
            exp_id(:)       = {num2str(ii)};
            gram_exp_id    = [gram_exp_id;exp_id];
        end
    end
    
    
    % gramm data
    gramm_calib.x_variable       = [gramm_calib.x_variable;gramm_x_var];
    gramm_calib.sim_dat   = [gramm_calib.sim_dat;gramm_sim_dat];
    gramm_calib.exp_dat   = [gramm_calib.exp_dat;gramm_exp_dat];
    gramm_calib.readout  = [gramm_calib.readout;gram_readout];
    gramm_calib.dose_time    = [gramm_calib.dose_time;gram_time_dose];
    gramm_calib.ligands  = [gramm_calib.ligands;gram_ligands];
    gramm_calib.experiment = [gramm_calib.experiment;gram_exp_id];  
    
    title_str = strcat('ligand :',{' '},ligand);
    figtitle(title_str{1})
    legend('Simulation','Experiment')
    
    % save figure
    f_name = strcat(fullfile(workdir,'Outcome'),'\model_fitting_result_',ligand,'_(',num2str(ii),').jpeg');
    saveas(fig,f_name)
    
end


%
%
%
%
%
%     for kk=1:length(EstimData.sim.resampled{ii})
%
%
%     figure('Position',[680   821   221   157])
%
%
%         if strcmp(dat_type,'time')%length(expTimePt)>1
%             plotshaded(exp_dat',[sim_dat_avg'-sim_dat_std';sim_dat_avg'+sim_dat_std'],rgb('Red'));
%             hold on
%             plot(exp_dat',sim_dat_avg','Color',rgb('Red'))
%             expdata=EstimData.expt.data{ii}{kk};
%             xlabel('time (hr)'),%title('simulation')
%             str1=EstimData.expt.names{ii}{kk};
%             str1=strcat(str1,' (norm.)');
%             ylabel(str1)
%             pbaspect([4 3 1]/4)
%             box off
%
%             hold on
%             plot(exp_dat,expdata/max(expdata),'-sb','LineWidth',1);
%             xlabel('time (hr)'),%title('experiment');
%             str1=EstimData.expt.names{ii}{kk};
%             str1=strcat(str1,' (norm.)');
%             ylabel(str1)
%             pbaspect([4 3 1]/4)
%             box off
%             %legend('Sim','Exp')
%             title(strcat('Stimulation=',Lig))
%
%             % SAVE data (prism format)
%             tmp_dat = [exp_dat sim_dat_avg sim_dat_std ones(size(sim_dat_avg))* size(dat_sim,2),...
%                 expdata/max(expdata) zeros(size(expdata))* size(expdata,2) ones(size(expdata))* size(expdata,2)];
%
% %             fname = strcat(pwd,'\fig.external\Fit_Outcome.xlsx')
% %             writetable(array2table(tmp_dat),fname,'Sheet',strcat(str1,'-',Lig,'-TC'))
%
%
%         elseif strcmp(dat_type,'dose')
%
%             expdose=EstimData.expt.dose{ii};
%
%
%             plotshaded(expdose',[sim_dat_avg'-sim_dat_std';sim_dat_avg'+sim_dat_std'],rgb('Red'));
%             hold on
%             plot(expdose',sim_dat_avg','Color',rgb('Red'))
%
%             %errorbar(expdose,simdata_avg,simdata_std,'-b','LineWidth',2)
%             expdata=EstimData.expt.data{ii}{kk};
%             xlabel('concentration (nM)'),%title('simulation')
%             str1=EstimData.expt.names{ii}{kk};
%             str1=strcat(str1,' (norm.)');
%             ylabel(str1)
%             pbaspect([4 3 1]/4)
%             box off
%             hold on
%
%             plot(expdose,expdata/max(expdata),'-sb','LineWidth',1)
%             xlabel('concentration (nM)'),%title('experiment')
%             str1=EstimData.expt.names{ii}{kk};
%             str1=strcat(str1,' (norm.)');
%             ylabel(str1)
%             pbaspect([4 3 1]/4)
%             %legend('Sim','Exp')
%             title(strcat('Stimulation=',Lig))
%
%
%
%         end
%     end
%
% end
%
%
%
%
% %             y: yellow
% %             m: magenta
% %             c: cyan
% %             r: red
% %             g: green
% %             b: blue
% %             w: white
% %             k: black