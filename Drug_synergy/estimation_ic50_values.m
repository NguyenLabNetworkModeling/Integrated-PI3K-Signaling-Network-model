%% estimation of IC50
if drug_synergy_opt.cell == 1
    load('dose-responses-data-parental')
elseif  drug_synergy_opt.cell == 2
    load('dose-responses-data-resistant')
end

sim_drug = drug_response.data;
dose_range = drug_response.range;
readouts = drug_response.readout;
drugs = drug_response.drug.Drug;


% get a steady state values
sim_drug_tss(:,:,:,:)=sim_drug(end,:,:,:,:); %[time,readout,dose,drugs,model]
% data structure
% d1: variables (readouts)
% d2: dose range
% d3: drugs
% d4 models


n1d = size(sim_drug_tss,1); % readout
n2d = size(sim_drug_tss,3); % drug
n3d = size(sim_drug_tss,4); % model
% total runs: 3850

parfor masterIDX=1:(n1d*n2d*n3d)
    
    disp(masterIDX)    
    
    % Subscripts from linear index
    [idx1,idx2,idx3]= ind2sub([n1d,n2d,n3d],masterIDX);
    
    dat_arry      = [];
    dat_arry(:,1) = sim_drug_tss(idx1,:,idx2,idx3);
    % normalize
    dat_arry_norm = dat_arry/dat_arry(1);
    
    % check the drug effect
    % max_potency   = abs(max(dat_arry_norm) - min(dat_arry_norm));
    max_potency     =  mean(dat_arry_norm(end-1:end)) - dat_arry_norm(1);
    
    % take away the minimum value
    dat_arry_cut    = dat_arry_norm-min(dat_arry_norm);
    
    
    data_fit = [];
    data_fit.data = dat_arry_cut;
    data_fit.dose_range = log10(dose_range);
    data_fit.type = {};
    
    % dose_range_log = log10(dose_range);
    
    
    
    if abs(max_potency) < 0.01 % no effect
        drug_sign(masterIDX)    = 0;
        ic50_values(masterIDX)  = NaN;
        
    elseif max_potency > 0 % agonoist
        drug_sign(masterIDX)    = +1;
        data_fit.type           = {'positive'};
        data_fit                = four_parameter_logistic(data_fit);
        ic50_values(masterIDX)  = data_fit.ic50;
        
    elseif max_potency < 0 % antagonist
        drug_sign(masterIDX)    = -1;
        data_fit.type           = {'negative'};
        data_fit                = four_parameter_logistic(data_fit);
        ic50_values(masterIDX)  = data_fit.ic50;
    end
end

%% POST-PROCESSING OF IC50 VALS

ic50_3d     = reshape(ic50_values,[n1d,n2d,n3d]);
sign_3d     = reshape(drug_sign,[n1d,n2d,n3d]);
% data structure
% d1: readouts (n =2)
% d2: drugs
% d3 models


for ii = 1:2
    
    dat_mat_1(:,:)  = ic50_3d(ii,:,:);
    % remove NaN
    dat_mat_1(isinf(dat_mat_1)) = NaN;
    % remove outlier
    dat_mat_1(isoutlier(dat_mat_1,'percentiles',[10,90],2)) = NaN;
    drug_ic50{ii} = dat_mat_1;
    
    % sign
    dat_mat_2(:,:) = sign_3d(ii,:,:);
    drug_sign_rf{ii} = dat_mat_2;
    
    
    % percentage of responsible models
    responsiveness{ii}= sum(~isnan(drug_ic50{ii}),2)/size(drug_ic50{ii},2)*100;
    
    fig = figure('Position',[680   800   560   178]);
    
    bar(nanmean(drug_ic50{ii},2))
    
    hold on
    
    xx = 1:size(drug_ic50{ii},1);
    yy = nanmean(drug_ic50{ii},2);
    yy_std_0 =  zeros(size(drug_ic50{ii},1),1);
    yy_std_1 =  nanstd(drug_ic50{ii},0,2);
    
    hh=errorbar(xx, yy,yy_std_0,yy_std_1);
    set(hh,'linestyle','none');
    set(gca,'YScale','log')
    ylabel(readouts{ii})
    xticks(xx)
    xticklabels(drugs)
    xtickangle(45)
    title('Averaged IC50 (with STD)')
    box off
    
end


%% save data

if drug_synergy_opt.cell == 1 % (parental)
    
    ic50matrix_parental_new.DataStruc   = {'readout','drugs','model'};
    ic50matrix_parental_new.ic50        = ic50_3d;
    ic50matrix_parental_new.drug        = drugs;
    ic50matrix_parental_new.readout     = readouts;
    
    fname = strcat(fullfile(workdir,'Outcome'),'\ic50matrix_parental_new.mat');
    save(fname, 'ic50matrix_parental_new')
    
elseif  drug_synergy_opt.cell == 2 % (resistant)
    
    ic50matrix_resistant_new.DataStruc  = {'readout','drugs','model'};
    ic50matrix_resistant_new.ic50       = ic50_3d;
    ic50matrix_resistant_new.drug       = drugs;
    ic50matrix_resistant_new.readout    = readouts;
    
    fname = strcat(fullfile(workdir,'Outcome'),'\ic50matrix_resistant_new.mat');
    save(fname, 'ic50matrix_resistant_new')
end

