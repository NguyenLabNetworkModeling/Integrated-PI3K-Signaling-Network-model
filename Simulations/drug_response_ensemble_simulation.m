%% Drug response to 

%% Load best-fitted param

%filename='Best_Fitted_Param_Sets_77.csv';
filename    = 'Best_Fitted_Param_Sets_77_MOD_kc2_rt_020b.csv';
par_vals    = csvread(filename,0,0)';
FIT_SCORE   = par_vals(1,:)';
param_sets  = par_vals(2:end,:);


%% design simulation time frame (starvation/Q/Byl)
% pre-stimulation
Stim_On     = param_sets(strcmp(PARAM_name,'IGF_on_time'),1);
T_PreStim   = linspace(0,Stim_On,50);
T_Stim      = T_PreStim(end) + linspace(0,500*60,300);
time_points = [0 1 3 6 18 24 48];
T_Drug      = T_Stim(end)+time_points*60;
tspan       = sort(unique([T_PreStim T_Stim T_Drug]));

% time index to read the time points
TI_PreStim  = tspan<=T_Stim(1);
TI_Stim     = and(tspan>=T_Stim(1),tspan<=T_Drug(1));
TI_Drug     = tspan>=T_Drug(1);

TS_PreStim  = tspan(TI_PreStim);
TS_Stim     = tspan(TI_Stim)-T_Stim(1);
TS_Drug     = tspan(TI_Drug)-T_Drug(1);


% Load IC50 Matrix, drug, readout
% (old) load ic50matrix_parental
load ic50matrix_parental_new
IC50_Matrix     = ic50matrix_parental_new;
% DataStruc: {'readout'  'drugs'  'model'}
%      ic50: [2×25×77 double]
%      drug: {25×1 cell}
%    readout: {2×1 cell} (1: pRB, 2: cyclinD)      
target_rd       = 1; %  (1: pRB, 2: cyclinD)
IC50_val(:,:)   = IC50_Matrix.ic50(target_rd,:,:);

% load drug lists
inhibitors  = readtable('model_target_drug_list.xlsx','ReadVariableNames',true);
drugs       = inhibitors.Drug;
drugON      = inhibitors.DrugON;

My_RD1_idx  = find(ismember(VARIABLE_name,{'phosphoS6','phosphoAkt','totalCd','totalp21'}));
My_RD1_name = VARIABLE_name(My_RD1_idx);

%% full media in growing condition

X0(strcmp(STATE_names,'IGF'))=13;
X0(strcmp(STATE_names,'HRG'))=1;

all_comb=[0 1; % BYL single
    1 0; % PDK1i single
    1 1]; % combination
drug_id = find(ismember(drugs,{'BYL719','pdk1i'}));

%% dose range

for mm =1:size(param_sets,2)  %1:77
    %param_id = selected_param(mm);
    for ii = 1:size(all_comb,1)
        
        dose_1 = IC50_val(drug_id(1),mm);
        dose_2 = IC50_val(drug_id(2),mm);
        
        % update parameter set
        param_vals = param_sets(:,mm);
        
        param_vals((strcmp(PARAM_name,drugs{drug_id(1)})))  = dose_1*all_comb(ii,1);
        param_vals((strcmp(PARAM_name,drugON{drug_id(1)}))) = T_Stim(end);
        
        param_vals((strcmp(PARAM_name,drugs{drug_id(2)})))  = dose_2*all_comb(ii,2);
        param_vals((strcmp(PARAM_name,drugON{drug_id(2)}))) = T_Stim(end);
        
        try
            % ODE solver (MEX)
            MES_output=pi3k_networkmodel(tspan,X0,param_vals',mex_options);
            
            % solution of ODEs
            state_values=MES_output.statevalues;
            variable_values=MES_output.variablevalues;
            % Sol_PreStim(:,:,ii)=variable_values(TI_PreStim,My_RD1_idx);
            % Sol_Qstim_(:,:,ii)=variable_values(TI_Stim,My_RD1_idx);
            Sol_Drug_inloop(:,:,ii)=variable_values(TI_Drug,My_RD1_idx);
            
            my_error{mm,ii} = {};
        catch ME
            Sol_Drug_inloop(:,:,ii)=nan;
            my_error{mm,ii} = ME.message;
        end
    end
    
    Sol_Drug(:,:,:,mm) = Sol_Drug_inloop(:,:,:);
    % data structure
    % 1d (row): time
    % 2d (column): state variables
    % 3d: combination (1,2: single, 3: combination)
    % 4d: models (n=77)
end

%% Plot response profiles to drug (singe and combo)
for ii=1:size(Sol_Drug,4) % model (n =77)
    % figure('Position',[1362         807         560         169])
    for jj=1:size(Sol_Drug,2) % state variables
        for kk = 1:size(Sol_Drug,3) % comb (singles/combs)
            dat1 = Sol_Drug(:,jj,kk,ii);
            resp_profiles_normal(:,jj,kk,ii) = dat1/dat1(1);
            % data structure
            % 1d (row): time
            % 2d (column): state variables
            % 3d: combination (1,2: single, 3: combination)
            % 4d: models (n=77)
            dat2(:,kk) = dat1/dat1(1);
        end
        
        subplot(1,size(Sol_Drug,2),jj),
        plot(TS_Drug/60,dat2,'LineWidth',1.5)
        % legend('byl719','pdk1i','both')
        pbaspect([4 3 1])
        box off
        ylabel(My_RD1_name{jj})
        xlabel('time(hr)')
        % axis tight
        title(strcat('Param id:',num2str((ii))))
        
    end
end

%% Plot averaged response profiles to drug (singe and combo)
%% time course plot
Sol_Drug_normal_mean = nanmean(resp_profiles_normal,4);
Sol_Drug_normal_se = nanstd(resp_profiles_normal,0,4)/sqrt(size(resp_profiles_normal,4));
% data structure
% 1d (row): time
% 2d (column): state variables
% 3d: combination (1,2: single, 3: combination)
fig_1 = figure;

for jj=1:size(Sol_Drug_normal_mean,2) % state variables
    
    dat_mean= [];
    dat_mean(:,:) = Sol_Drug_normal_mean(:,jj,:);
    dat_se= [];
    dat_se(:,:) = Sol_Drug_normal_se(:,jj,:);
    
    subplot(1,size(Sol_Drug,2),jj),
    pl = plot(TS_Drug/60,dat_mean,'LineWidth',1.5);
    %legend('byl719','pdk1i','both')
    pbaspect([4 3 1])
    box off
    ylabel(My_RD1_name{jj})
    xlabel('time(hr)')
    
    hold on
    TS_mat = repmat(TS_Drug'/60,1,3);
    erbar = errorbar(TS_mat,dat_mean,dat_se,'LineWidth',1.5);
    erbar(1).DisplayName ='PI3Kai';
    erbar(2).DisplayName ='PDK1i';
    erbar(3).DisplayName ='PI3Kai+PDK1i';
    
    % Save data
    tbl_dat= [array2table(time_points') array2table(dat_mean) array2table(dat_se)];
    fname = strcat(workdir,'\Outcome','\Drug_responses_ensemble.xlsx');
    sheetname = My_RD1_name{jj};
    writetable(tbl_dat,fname,'Sheet',sheetname);
    
end

fname_fig_1 = strcat(workdir,'\Outcome\',strcat('Drug_responses_ensemble','.jpeg'));
saveas(fig_1,fname_fig_1)

%% Statistical test (p-value)
% single vs Both
resp_profiles_tss(:,:,:) = resp_profiles_normal(end,:,:,:);
% 1d: state variables
% 2d: combination (1,2: single, 3: combination)
% 3d: model (n=77)

for ii = 1:size(resp_profiles_tss,1)
    s1_dat(:,1) = resp_profiles_tss(ii,1,:);
    s2_dat(:,1) = resp_profiles_tss(ii,2,:);
    both_dat(:,1) = resp_profiles_tss(ii,3,:);
    
    [~,pval(ii,1)]=ttest(s1_dat,both_dat);
    [~,pval(ii,2)]=ttest(s2_dat,both_dat);
end

array2table(pval,'RowNames',My_RD1_name,...
'VariableNames',{'Single-1 vs Combo','Single-2 vs Combo'})

