%% Figure 1B: Comparison of model predictions and experimental data

clear; clc; close all;

load('workSpace_Fig1B.mat')

%%  Producing the figures

for ii=1:length(EstimData.sim.resampled) % experiments

    exp_dat        = EstimData.expt.data{ii}; % note: not normalized
    sim_dat_avg    = dat_sim_norm_avg{ii};
    sim_dat_std    = dat_sim_norm_std{ii};
    dat_type       = EstimData.expt.type{ii}{1};


    if strcmp(dat_type,'dose')

        xx          = EstimData.expt.dose{ii};
        proteins    = EstimData.expt.names{ii};
        proteins    = strrep(proteins,'phospho','p');
        proteins    = strrep(proteins,'total','');
        x_lab       = dat_type;
        ligand      = EstimData.expt.ligand{ii}{1};

        for jj = 1:length(sim_dat_avg)


            figure('Position',[680   592   286   286])

            yy_sim = sim_dat_avg{jj}/max(sim_dat_avg{jj});
            yy_std = sim_dat_std{jj};
            yy_exp = exp_dat{jj}/max(exp_dat{jj});

            plotshaded(xx',[yy_sim-yy_std yy_sim+yy_std]',rgb('blue'))
            hold on
            plot(xx,yy_sim,'-ob','LineWidth',1,...
                'MarkerFaceColor',[0 0 1],...
                'MarkerEdgeColor',[0 0 1])

            hold on
            plot(xx,yy_exp,'-sr','LineWidth',1,...
                'MarkerFaceColor',[1 0 0],...
                'MarkerEdgeColor',[1 0 0])

            ylabel(strcat(proteins{jj},'(norm.)'));
            xlabel('conc.(nM)')
            axis([0 inf 0 1.2 ])
            title(strcat(ligand,' stimulation (dose response)'))
            box off
            offsetAxes
            legend('SEM(simulation)','Simulation','Experiment')

        end

    elseif strcmp(dat_type,'time')

        xx          = EstimData.expt.time{ii};
        proteins    = EstimData.expt.names{ii};
        proteins    = strrep(proteins,'phospho','p');
        proteins    = strrep(proteins,'total','');
        x_lab       = dat_type;
        ligand      = EstimData.expt.ligand{ii}{1};

        for jj = 1:length(sim_dat_avg)

            figure('Position',[680   592   286   286])

            yy_sim = sim_dat_avg{jj}/max(sim_dat_avg{jj});
            yy_std = sim_dat_std{jj};
            yy_exp = exp_dat{jj}/max(exp_dat{jj});

            plotshaded(xx',[yy_sim-yy_std yy_sim+yy_std]',rgb('blue'))
            hold on
            plot(xx,yy_sim,'-ob','LineWidth',1,...
                'MarkerFaceColor',[0 0 1],...
                'MarkerEdgeColor',[0 0 1])

            hold on
            plot(xx,yy_exp,'-sr','LineWidth',1,...
                'MarkerFaceColor',[1 0 0],...
                'MarkerEdgeColor',[1 0 0])
            legend('SEM(simulation)','Simulation','Experiment')


            ylabel(strcat((proteins{jj}),'(norm.)'));
            xlabel('time (min)')
            title(strcat(ligand,' stimulation (time course)'))
            axis([0 inf 0 1.2 ])
            box off
            offsetAxes
        end
    end
end
