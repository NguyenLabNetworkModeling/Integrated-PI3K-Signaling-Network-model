%% BYL responses of parental and resistant cells

%% THE BEST-FITTED PARAMETER SETS

% load the best-fitted parameter sets
filename='Best_Fitted_Param_Sets_77_MOD_kc2_rt_020b.csv';
par_vals = readmatrix(filename);
param_sets = par_vals(:,2:end)';


%% Simulation time frame
QTime = param_sets((strcmp(PARAM_name,'IGF_on_time')),1);
QTime = param_sets((strcmp(PARAM_name,'HRG_on_time')),1);

% <-- Starvation --> 2000 <-- Qstim --> 3000 <-- Drug -->
tspan=linspace(1,5000*60,100);

% time frame for drug response
tspan_drug=[0 1 3 6 18 24 48]*60;
%sort(unique([tspan_drug linspace(0,96*60,500)]));


my_readouts={'phosphoAkt','phosphoErk','phosphoS6','phosphoRB','totalp21','phosphoNDRG1'};
var_idx=find(ismember(VARIABLE_name,my_readouts));
readout_names = VARIABLE_name(var_idx);


% CellType = 1;
% BYL dose = 1000 nM
byl_dose=1000;

%%
% Run simulation


for ss=1:size(param_sets,2)
    
    disp(ss)
    
    param_vals     =   param_sets(:,ss);
    x0s_sim0       =   X0;
    
    
    %%%% Sim 0 - growing condition %%%%
    param_vals_s0 =  param_vals;
    
    % no BYL treatment
    param_vals_s0((strcmp(PARAM_name,'BYL719')))        =   0;
    param_vals_s0((strcmp(PARAM_name,'BYL719_on_time')))=   0;
    
    % under growing condition (full medium)
    x0s_sim0(strcmp(STATE_names,'IGF')) = 13;
    x0s_sim0(strcmp(STATE_names,'HRG')) = 1;
    % NOTE: IGF and HRG are ON at 2000 (Qtime)
    
    % ODE solver (MEX)
    try
        mex_out0 = pi3k_networkmodel(tspan,x0s_sim0,param_vals_s0',mex_options);
        sim0_state_val   = mex_out0.statevalues;
    catch
        sim0_state_val = ones(length(x0s_sim0),length(STATE_names))*NaN;
    end
    x0s_sim1            = sim0_state_val(end,:); % for drug response of parental
    x0s_sim2            = sim0_state_val(end,:); % for drug response of resistant
    x0s_sim3            = sim0_state_val(end,:); % for drug response of DMSO
    %
    %
    %
    %
    %
    %
    %
    %%%% Sim-1 : BYL response of parental cells  %%%%
    param_vals_sim1     = param_vals;
    
    % IGF, HRG stimulation
    % be very careful (IGF, HRG is already turned on in the previous simulation)
    % So, IGF and HRG IGF and HRG on time should be zero (0)
    param_vals_sim1((strcmp(PARAM_name,'IGF_on_time')))=0;
    param_vals_sim1((strcmp(PARAM_name,'HRG_on_time')))=0;
    
    param_vals_sim1((strcmp(PARAM_name,'BYL719')))=byl_dose;
    param_vals_sim1((strcmp(PARAM_name,'BYL719_on_time')))=0;
    
    % ODE solver (MEX)
    try
        mex_out1 = pi3k_networkmodel(tspan_drug,x0s_sim1,param_vals_sim1',mex_options);
        sim1_var_vals = mex_out1.variablevalues;
    catch
        sim1_var_vals = ones(length(tspan_drug),length(VARIABLE_name))*NaN;
    end
    sim1_parent(:,:,ss) = (sim1_var_vals(:,:));
    %
    %
    %
    %
    %
    %
    %
    %%%% Sim-2: BYL response of the resistant cells %%%%
    param_vals_sim2     = param_vals;
    
    % customization of the parental model to resistance
    x0s_sim2 = Customization_Resistant_Model(x0s_sim2,STATE_names);
    
    param_vals_sim2((strcmp(PARAM_name,'BYL719')))          = byl_dose;
    param_vals_sim2((strcmp(PARAM_name,'BYL719_on_time')))  = 0;
    
    param_vals_sim2((strcmp(PARAM_name,'IGF_on_time'))) =0;
    param_vals_sim2((strcmp(PARAM_name,'HRG_on_time'))) =0;
    
    % ODE solver (MEX)
    try
        mex_output2 = pi3k_networkmodel(tspan_drug,x0s_sim2,param_vals_sim2',mex_options);
        sim2_var_vals           = mex_output2.variablevalues;
    catch
        sim2_var_vals           = ones(length(tspan_drug),length(VARIABLE_name))*NaN;
    end
    sim2_resistant(:,:,ss)  = sim2_var_vals(:,:);
    %
    %
    %
    %
    %
    %
    %
    %%%% Sim-3: DMSO of the resistant cells %%%%
    param_vals_sim3=param_vals;
    
    % customization of the parental model to resistance
    x0s_sim3 = Customization_Resistant_Model(x0s_sim3,STATE_names);
    
    % Note BYL = 0 for DMSO
    param_vals_sim3((strcmp(PARAM_name,'BYL719')))=0;
    param_vals_sim3((strcmp(PARAM_name,'BYL719_on_time')))=0;
    
    param_vals_sim3((strcmp(PARAM_name,'IGF_on_time')))=0;
    param_vals_sim3((strcmp(PARAM_name,'HRG_on_time')))=0;
    
    % ODE solver (MEX)
    try
        mex_out3 = pi3k_networkmodel(tspan_drug,x0s_sim2,param_vals_sim3',mex_options);
        sim3_var_vals   = mex_out3.variablevalues;
    catch
        sim3_var_vals   = ones(length(tspan_drug),length(VARIABLE_name))*NaN;
    end
    sim3_DMSO(:,:,ss)   = sim3_var_vals(:,:);
end




%% Normalization of Byl responses of resistannt cell by DMSO
% sim0 : control (no Byl) sim1 : Byl response (parental) sim2 : Byl response
% (resistant) sim3 : Byl response (DMSO)

% step 1: normalization (resistant cells) by DMSO
sim2_resist_norm=sim2_resistant./sim3_DMSO;

for ii=1:size(param_sets,2)
    
    % normalization (parental cells) by the basal level
    dat_array(:,:) = sim1_parent(:,:,ii);
    sim1_parent_norm(:,:,ii)=dat_array./repmat(dat_array(1,:),size(dat_array,1),1);
    
    % {'p21(1)','Cd(2)','pAkt(3)','pNDRG1(4)','CDK4(5)','pS6(6)','pERK(7)','pRb(8)'};
    taget_sp_rd = {'totalp21','totalCd','phosphoAkt','phosphoNDRG1','CDK4','phosphoS6','phosphoErk','phosphoRB'};
    
    
    dat_mat = sim2_resist_norm(:,:,ii);
    
    % functiona call ()
    dat_mat_adjusted = adjust_resistant_model(dat_mat,VARIABLE_name);
    
    sim2_resist_adjusted(:,:,ii) = dat_mat_adjusted.data;
end


sim1_parent_norm_output      = sim1_parent_norm(:,ismember(VARIABLE_name,readout_names),:);
sim2_resist_adjusted_output  = sim2_resist_adjusted(:,ismember(VARIABLE_name,readout_names),:);




%% plot all models (parental, dummy, resistant-1, resistant-2)

fig = figure('position',[ 681   710   511   269]);
for ii = 1:length(readout_names)
    
    dat_parent_mat(:,:)=sim1_parent_norm_output(:,ii,:);
    dat_resist_mat(:,:)=sim2_resist_adjusted_output(:,ii,:);
    
    % standard error
    num_samples = sum(~any(isnan(dat_parent_mat)));
    std_error_par = nanstd(dat_parent_mat,0,2)/sqrt(num_samples);
    
    xx = [];
    % for the parental model (shaded plot)
    xx(:,1) = tspan_drug/60;
    dat_avg_par = nanmean(dat_parent_mat,2);
    yy_lower = dat_avg_par' - std_error_par';
    yy_upper = dat_avg_par' + std_error_par';
    yy =[yy_lower' yy_upper'];
    
    subplot(2,3,ii),plotshaded(xx',yy,rgb('Blue'));
    hold on
    
    % for the parental model (normal plot)
    yy_par = nanmean(dat_parent_mat,2);
    
    subplot(2,3,ii),plot(xx',yy_par,'b')
    legend('off')
    hold on
    
    
    % for the resistant model (shaded)
    std_error_rp = nanstd(dat_resist_mat,0,2)/sqrt(num_samples);
    
    dat_avg_rp = nanmean(dat_resist_mat,2);
    yy_lower = dat_avg_rp' - std_error_rp';
    yy_upper = dat_avg_rp' + std_error_rp';
    
    yy =[yy_lower' yy_upper'];
    
    subplot(2,3,ii),plotshaded(xx',yy,rgb('Red'));
    hold on
    
    % for the resistant model (normal)
    yy_rp = nanmean(dat_resist_mat,2)';
    subplot(2,3,ii),plot(xx',yy_rp,'r')
    legend('off')
    
    
    % xticks modification
    num_xticks      = 4;
    xticks_interval = xx(end)/num_xticks;
    xticks_end      = xx(end);
    xticks(0:xticks_interval:xticks_end)
    xticks_lab      = strsplit(num2str([0:xticks_interval:xticks_end]));
    xticklabels(xticks_lab)
    xtickangle(45)
    xlabel('time (hr)')
    
    ylabel(readout_names{ii})
    pbaspect([4 3 1])
    axis([-2 inf 0 inf])
    
    
    % save data
    tbl_dat = array2table([xx dat_avg_par  std_error_par*sqrt(num_samples) dat_avg_rp std_error_rp*sqrt(num_samples)],...
        'VariableNames',{'time(h)','parental(avg)','parental(std)','resistant(avg)','resistant(std)'});
    fname = strcat(fullfile(workdir,'Outcome'),'\model_validation_byl','.xlsx');
    
    writetable(tbl_dat,fname,'Sheet',readout_names{ii})
    
end


% save figure
fname = strcat(fullfile(workdir,'Outcome'),'\model_validation_byl','.jpeg');
saveas(fig,fname)
