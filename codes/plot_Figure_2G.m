%% Figure 2G: Simulation of phospho-AKT, phospho-S6, and cyclin D1 levels to BYL719 and GSK2334470

clear; clc; close all;

%% Producing the figures

filename = 'Fig2G simulation raw data.xlsx';
sheets = sheetnames(filename);

figure('Position',[680   625   772   253])

for ii = 1:length(sheets)
    dat = readtable(filename,'Sheet',sheets{ii});
    time_lab = dat.time;

    % PI3Kai
    subplot(1,3,ii)
    errorbar(time_lab,dat.PI3K_i_avg,dat.PI3K_i_std,...
        'LineWidth',1.5,...
        'Color','blue')

    % PDK1i
    hold on
    errorbar(time_lab,dat.PDK1i_avg,dat.PDK1i_std,...
        'LineWidth',1.5,...
        'Color','red')


    % PI3Kai + PDK1i
    hold on
    errorbar(time_lab,dat.PI3K_i_PDK1i_avg,dat.PI3K_i_PDK1i_std,...
        'LineWidth',1.5,...
        'Color',rgb('Gold'))

    box off
    legend({'PI3Kai','PDK1i','PI3Kai + PDK1i'})
    xlabel('time(h)')
    ylabel(strcat(sheets{ii},'(norm.)'))
    set(gca,'FontSize',10)

end




