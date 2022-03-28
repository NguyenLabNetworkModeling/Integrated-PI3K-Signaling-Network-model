%%
Data_Format_VER_2



filename='Best_Fitted_Param_Sets_77_MOD_kc2_rt_020b.csv';

par_vals = readmatrix(filename);
param_sets = par_vals(:,2:end)';


%params = pi3k_networkmodel('parameters');
%% LOAD DATAFORMAT FILE




%% LOAD VALILATION DATASETS

%datapath = 'C:\Users\sshin\Google Drive\RESEARCH\_Antonella Papa\data\quantification';
datafile='24 hrs timecourse with full medium.xlsx';
sheetname='pRb pS6 Cd';
[num,txt,raw] = xlsread(datafile,sheetname,'B25:G32');

validation.exp_readout{4}='phosphoRB';
validation.exp_readout{3}='phosphoS6';
%validation.exp_readout{3}='totalCd';
validation.exp_readout{1}='phosphoErk';
validation.exp_readout{2}='phosphoAkt';
validation.exp_data{4}=num(1:end-1,2);
validation.exp_data{3}=num(1:end-1,3);
%validation.exp_data{3}=num(1:end-1,4);
validation.exp_data{1}=num(1:end-1,5);
validation.exp_data{2}=num(1:end-1,6);
validation.exp_time=num(1:end-1,1);
Sampoints(1,:) = validation.exp_time;


% main readouts of the model
my_readouts={'phosphoErk','phosphoAkt','phosphoS6','phosphoRB'};
for ii=1:length(my_readouts)
    var_idx(ii)=find(ismember(EstimData.model.varnames,my_readouts{ii}));
end


%% SIMULATION TIME FRAME [STARVATION -> GROWING -> BYL TREATMENT]
% Q-stimulation:

QTime = param_sets((strcmp(PARAM_name,'IGF_on_time')),1);
QTime = param_sets((strcmp(PARAM_name,'HRG_on_time')),1);

% time section for starvation
t_starv = linspace(0,QTime,50);
t_stim  = sort(unique([Sampoints linspace(0,9000,100)])) + t_starv(end);
t_drug  = [0 24]*60 + t_stim(end);
tspan   = sort(unique([t_starv t_stim t_drug]));

t_idx_starv = tspan<=t_stim(1);
t_idx_stim  =and(tspan>=t_stim(1),tspan<=t_drug(1));
t_idx_byl   =tspan>=t_drug(1);

tspan_starv =tspan(t_idx_starv);
tspan_stim  =tspan(t_idx_stim)-t_stim(1);
tspan_byl   =tspan(t_idx_byl)-t_drug(1);


%% simulation with fitted params

parfor jj=1:size(param_sets,2)
    
    disp(jj)
    
    x0S = X0;
    
    % BYL treatment (dose = 1000 nM)
    param_vals  = param_sets(:,jj);
    param_vals(strcmp(PARAM_name,'IGF_on_time')) = QTime;
    param_vals(strcmp(PARAM_name,'HRG_on_time')) = QTime;
    
    param_vals(strcmp(PARAM_name,'BYL719'))         = 1000;
    param_vals(strcmp(PARAM_name,'BYL719_on_time')) = t_stim(end);
    
    x0S(strcmp(STATE_names,'IGF'))=13; % IGF
    x0S(strcmp(STATE_names,'HRG'))=1; % HRG
    
    % ODE solver (MEX)
    mex_out     = pi3k_networkmodel(tspan,x0S,param_vals',mex_options);
    mex_state   = mex_out.statevalues;
    mex_val     = mex_out.variablevalues;
    
    resp_starv(:,:,jj)  = mex_val(t_idx_starv,var_idx);
    resp_Qstim(:,:,jj)      = mex_val(t_idx_stim,var_idx);
    resp_byl(:,:,jj)    = mex_val(t_idx_byl,var_idx);
end




%% check plot

figure;

dat_set.dat{1} = resp_starv;
dat_set.dat{2} = resp_Qstim;
dat_set.dat{3} = resp_byl;

dat_set.time{1} = tspan_starv;
dat_set.time{2} = tspan_stim;
dat_set.time{3} = tspan_stim;

id = 2;
for ii=1:size(dat_set.dat{id},2)
    
    xx      = dat_set.time{id}/60;
    yy(:,:) = dat_set.dat{id}(:,ii,:);
    
    subplot(2,2,ii),
    plot(xx,yy);
    xlabel('time(h)'),
    ylabel(my_readouts{ii})
end



%% time profiles to Qstim

Qstim_samp_idx  = ismember(round(tspan_stim,5),round(Sampoints,5));
tspan_Q_exp     = tspan_stim(Qstim_samp_idx);

ref_idx=[6 6 6 4 3 6];

figure('Position',[680   725   337   253]);

for ii=1:size(resp_Qstim,2)
    
    mat_var1(:,:)   = resp_Qstim(Qstim_samp_idx,ii,:);
    mat_var1        =mat_var1./repmat(mat_var1(3,:),size(mat_var1,1),1);
    
    % remove (extreme) outliner
    max_var1    = max(mat_var1);
    out_bound   = quantile(max_var1,0.75)*10;
    mat_var1(:,max_var1>out_bound)  = NaN;
    num_data=size(mat_var1,2)-sum(max_var1>out_bound);
    
    subplot(2,2,ii),
    
    xx      = tspan_Q_exp/60;
    yy      = nanmean(mat_var1,2)';
    yy_sd   = nanstd(mat_var1,0,2)';
    
    errorbar(xx,yy,yy_sd,'LineWidth',2);
    axis([0 inf 0 inf])
    pbaspect([4 3 1])
    offsetAxes
    box off
    hold on
    
    
    tgt_idx2 = find(ismember(validation.exp_readout,my_readouts{ii}));
    
    if ~isempty(tgt_idx2)
        
        xx      = validation.exp_time/60;
        dat_mat = validation.exp_data{tgt_idx2};
        yy      = dat_mat/dat_mat(ref_idx(ii));
        
        subplot(2,2,ii),
        
        plot(xx,yy,'-s','LineWidth',2);
        pbaspect([4 3 1])
        box off
    end
    
    xlabel('time(h)'),
    ylabel(my_readouts{ii})
    if ii==1;legend('sim','exp');end
    hold off
end





%% figure byl-dose responses (at 24 hr)

figure('Position',[680   763   281   215]);


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
    
    set(gca,'LineWidth',1)
    xticks(1:length(tspan_byl))
    xticklabels({})
    xlabel('time(h)'),
    ylabel(my_readouts{ii})
    hold on
    
    xx = 1:length(tspan_byl/60);
    yy = nanmean(mat_var1,2)';
    bar(xx,yy,'LineWidth',1);
    set(gca,'LineWidth',1)
    xticks(1:length(tspan_byl));
    xticklabels(num2str(tspan_byl'/60))
    pbaspect([4 3 1])
    box off
    
    
    tbl = array2table([nanmean(mat_var1,2) nanstd(mat_var1,0,2) [num_data;num_data]],...
        'VariableNames',{'avg','se','num'});
    
end