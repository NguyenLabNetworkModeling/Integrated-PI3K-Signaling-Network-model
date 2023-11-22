%% Figure S1D: Model validation using independent experimental data

clear; clc; close all;

load('workSpace_FigS1D.mat')



%%  Producing the figures

figure('Position',[680   574   456   404]);


for ii=1:size(resp_byl,2)

    mat_var1 = [];
    mat_var1(:,:)   = resp_byl(:,ii,:);
    mat_var1        = mat_var1./repmat(mat_var1(1,:),size(mat_var1,1),1);


    max_var1    = max(mat_var1);
    out_bound   = quantile(max_var1,0.75)*5;
    mat_var1(:,max_var1>out_bound) = NaN;
    num_data    = size(mat_var1,2)-sum(max_var1>out_bound);

    subplot(2,2,ii),

    xx = nanmean(mat_var1,2)';
    yy = nanstd(mat_var1,0,2)'/sqrt(num_data);
    errorbar(xx,yy,'.','LineWidth',1);

    set(gca,'LineWidth',1,'FontSize',10)
    xticks(1:length(tspan_byl))
    xticklabels({'GC(24h)','BYL(24h)'})
    ylabel(strcat(my_readouts{ii},'(norm.)'))
    hold on

    xx = 1:length(tspan_byl/60);
    yy = nanmean(mat_var1,2)';
    bar(xx,yy,'LineWidth',1);
    set(gca,'LineWidth',1,'FontSize',10)
    xticks(1:length(tspan_byl));
    xlabel({}),
    xtickangle(45)
    pbaspect([4 3 1])
    box off

    figtitle('Model validation with independent experimental data')



end