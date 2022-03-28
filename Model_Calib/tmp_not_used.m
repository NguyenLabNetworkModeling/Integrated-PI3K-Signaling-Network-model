%% Methods for visualizing repeated trajectories
% gramm supports 2D inputs for X and Y data (as 2D array or cell of
% arrays), which is particularly useful for representing repeated
% trajectories. Here for example we generate 50 trajectories, each of
% length 40. The grouping data is then given per trajectory and not per
% data point. Here the color grouping variable is thus given as a 1x50
    % cellstr.

%We generate 50 trajectories of length 40, with 3 groups
% N=50;
% nx=40;
% cval={'A' 'B' 'C'};
% cind=randi(3,N,1);
% c=cval(cind);
% x=linspace(0,3,nx);
% y=arrayfun(@(c)sin(x*c)+randn(1,nx)/10+x*randn/5,cind,'UniformOutput',false);



c=gram_calib_type;
x=EstimData.expt.dose{1};
y=gram_calib_dat{1}{1}';


            

clear g
g(1,1)=gramm('x',x,'y',y,'color',c);
g(1,2)=copy(g(1));
g(2,1)=copy(g(1));
g(2,2)=copy(g(1));

g(1,1).geom_point();
g(1,1).set_title('geom_point()');

g(1,2).geom_line();
g(1,2).set_title('geom_line()');

g(2,1).stat_smooth();
g(2,1).set_point_options('base_size',3);
g(2,1).set_title('stat_smooth()');


g(2,2).stat_summary();
g(2,2).set_title('stat_summary()');

g.set_title('Visualization of repeated trajectories ');

figure('Position',[100 100 800 550]);
g.draw();
