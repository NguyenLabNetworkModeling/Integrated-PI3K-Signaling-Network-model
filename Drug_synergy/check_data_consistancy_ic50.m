%% Check result consistency  

load('ic50matrix_parental') 
load('ic50matrix_resistant') 
load('ic50matrix_parental_new') 
load('ic50matrix_resistant_new') 



% parental old and new (readout - 1) 
dat_par_old{1}(:,:) = ic50matrix_parental.ic50(1,:,:);
dat_par_new{1}(:,:) = ic50matrix_parental_new.ic50(1,:,:);

% resistant old and new (readout - 1)
dat_rp_old{1}(:,:) = ic50matrix_resistant.ic50(1,:,:);
dat_rp_new{1}(:,:) = ic50matrix_resistant_new.ic50(1,:,:);

% parental old and new (readout - 2) 
dat_par_old{2}(:,:) = ic50matrix_parental.ic50(2,:,:);
dat_par_new{2}(:,:) = ic50matrix_parental_new.ic50(2,:,:);

% resistant old and new (readout - 2)
dat_rp_old{2}(:,:) = ic50matrix_resistant.ic50(2,:,:);
dat_rp_new{2}(:,:) = ic50matrix_resistant_new.ic50(2,:,:);


%% comparision1

rd_idx = 2;
rd = ic50matrix_parental_new.readout{rd_idx};
nn = 'parental vs resistant';
% 'new vs old (parental)'
% 'new vs old (resistant)'
% 'parental vs resistant'

switch nn
    
    case 'new vs old (parental)'
        test_title = strcat(nn,'-',rd);
        xx = log10([dat_par_new{rd_idx}(:),dat_par_old{rd_idx}(:)]);
        
    case 'new vs old (resistant)'
        test_title = strcat(nn,'-',rd);
        xx = log10([dat_rp_new{rd_idx}(:),dat_rp_old{rd_idx}(:)]);
        
    case 'parental vs resistant'
        test_title = strcat(nn,'-',rd);
        xx = log10([dat_par_new{rd_idx}(:),dat_rp_new{rd_idx}(:)]);
end

% remove (1) log(x) > 50, (2) NaN, (3) Inf
xx(any(abs(xx)>50,2),:) = [];
xx(any(isnan(xx),2),:) = [];
xx(any(isinf(xx),2),:) = [];

rho = corr(xx(:,1),xx(:,2));

fig = figure('position',[667   673   387   255]);
scatter(xx(:,1),xx(:,2))
xlabel('Estimated IC50 (log10)')
ylabel('Estimated IC50 (log10)')
xline(0,'--')
yline(0,'--')
title({strcat('correlation = ',num2str(rho));test_title})
pbaspect([4 3 1])

fname = strcat(fullfile(workdir,'Outcome'),'\Check_consistency_',test_title,'.jpeg');
saveas(fig,fname)


