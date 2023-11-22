%% Figure 1E: Model prediction of signaling response to BYL719

clear; clc; close all;


%% Producing the figures

filename = 'Figure_1E_simulaiton_raw_data.xlsx';
sheets = sheetnames(filename);

figure('Position',[ 680   684   674   194])

for ii = 1:length(sheets)
    dat = readtable(filename,'Sheet',sheets{ii});
    time_lab = dat.time_hr_;

    subplot(1,3,ii)
    errorbar(time_lab,dat.Parental_avg,dat.Parental_std./sqrt(dat.Parental_num),...
        'LineWidth',1.5,...
        'Color','blue',...
        'Marker','o',...
        'MarkerSize',8)

    hold on
    errorbar(time_lab,dat.Resistant_avg,dat.Resistant_std./sqrt(dat.Resistant_num),...
        'LineWidth',1.5,...
        'Color','red',...
        'Marker','square',...
        'MarkerSize',8)

    box off
    [lgd, icons, plots, txt] = legend('show');

    legend({'Parental','Resistant'})

    xlabel('time(h)')
    ylabel(strcat(sheets{ii},'(norm.)'))
    set(gca,'FontSize',10)



end




