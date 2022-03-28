%% Comparison of Responses between Parental and Resistant Models

PI3K_Simulation_Common

foldname = 'Fig_comp_resps_p21';
mkdir(strcat(outdir,'\',foldname))
%%
filename1a='totalCd_to_p21KDnOE_Parental.csv';
filename1b='totalCd_to_p21KDnOE_Resistant.csv';
filename2a='phosphoRB_to_p21KDnOE_Parental.csv';
filename2b='phosphoRB_to_p21KDnOE_Resistant.csv';
RD_lab = {'Cyclin D1','pRB'};


dat{1}{1} = readmatrix(filename1a,'Range','B1:BZ6');
dat{1}{2} = readmatrix(filename1b,'Range','B1:BZ6');
dat{2}{1} = readmatrix(filename2a,'Range','B1:BZ6');
dat{2}{2} = readmatrix(filename2b,'Range','B1:BZ6');

p21_range = readmatrix(filename1a,'Range','A1:A6');

for jj = 1:2
    for ii = 1:size(dat{1}{1},2)
        
        p1 = plot(p21_range,[dat{jj}{1}(:,ii),dat{jj}{2}(:,ii)]);
        xlabel('p21(log10)'),ylabel(RD_lab{jj})
        set(gca, 'XScale', 'log')
        legend('Parantal','Resistant')
        title(strcat('Model ID:',{' '},num2str(ii)))
        grid on
        
        fname =strcat(outdir,'\',foldname,'\',...
            strcat('Comparison_p21_btw_Par_Res_',RD_lab{jj},'_',num2str(ii),'.jpg'));
        
        saveas(gcf,fname)
    end
end

