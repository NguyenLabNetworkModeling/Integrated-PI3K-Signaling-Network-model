
gramm_calib.difference = gramm_calib.sim_dat - gramm_calib.exp_dat;
rho =corr(gramm_calib.exp_dat,gramm_calib.sim_dat);


%% Scatter plot
g(1,1)=gramm('x',gramm_calib.sim_dat,'y',gramm_calib.exp_dat,...    
    'color',gramm_calib.experiment);
g(1,1).geom_point();
g(1,1).set_names('x','Simulation Data (norm.)','y','Experiment Data (norm)','color','Training Set');
g(1,1).set_title({'Goodness';strcat('(rho=',num2str(rho),')')});

% Corner histogram
g(1,1).geom_point();
g(1,1).stat_cornerhist('edges',-1:0.1:1,'aspect',0.4);
g(1,1).geom_abline();


%% violin plot

g(1,2)=gramm('x',gramm_calib.experiment,'y',gramm_calib.difference,'color',gramm_calib.readout);

g(1,2).stat_violin('fill','transparent');
g(1,2).set_title('Discrepancy');
g(1,2).set_names('x','training Set','y','Difference','color','Readout');

fig = figure('Position',[699   584   598   304]);
g.draw();

fname = strcat(fullfile(workdir,'/Outcome'),'/scatter_fitting_result');
saveas(fig,fname,'jpeg')
saveas(fig,fname,'fig')

