%% Figure 4AB: Model predictions assessing inter-dependency between p21 levels

clear; clc; close all

cell_type = {
    'parental';
    'resistant';
    };

[ atype ] = readInput(cell_type);
CellType = cell_type{atype};

switch CellType

    case 'parental'

        load('workSpace_Fig4A.mat')
        col_pick = 'blue';

    case 'resistant'

        load('workSpace_Fig4B.mat')
        col_pick = 'red';
end



%% Producing the figures

filename='Best_Fitted_Param_Sets_77_MOD_kc2_rt_020b.csv';
par_vals = readmatrix(filename)';
param_sets = par_vals(2:end,2:end);
PARAM_table = array2table(param_sets,"RowNames",PARAM_name);


%% Simulation time frame
QTime = param_sets((strcmp(PARAM_name,'HRG_on_time')),1);

% <-- Starvation --> 2000 <-- Qstim --> 2000 <-- Drug -->
tspan=linspace(1,5000*60,100);
tspan_drug=[0 1 6 12 24 48 96]*60;

% byl treatment
byl_dose=1000;

%% P21 expression inverval
p21_range=10.^[-2 -1 0 1 2 3 4];

%% parallelizing loops

n1d=length(p21_range);
n2d=size(param_sets,2);

parfor masterIDX=1:(n1d*n2d)

    % Subscripts from linear index
    [idx1,idx2]=ind2sub([n1d,n2d],masterIDX);

    try
        param_val_ref=param_sets(:,idx2);
        tmp_idx1=find(ismember(PARAM_name,'vs_cc_020'));
        % vs_cc_020: p21 transcription parameter
        param_val_ref(tmp_idx1)=param_val_ref(tmp_idx1).*p21_range(idx1);

        %%%% Sim-1: Growing Condition, QTime: 2000, IGF,HRG: ON %%%%
        % No drug
        param_vals_sim1=param_val_ref;
        param_vals_sim1((strcmp(PARAM_name,'BYL719')))=0;
        param_vals_sim1((strcmp(PARAM_name,'BYL719_on_time')))=0;

        % Qstim at T = 2000
        X0_sim1 = X0;
        X0_sim1(strcmp(STATE_names,'IGF'))=13;
        X0_sim1(strcmp(STATE_names,'HRG'))=1;
        % NOTE: IGF and HRG are ON at 2000 (Qtime)

        MEX_out1=pi3k_networkmodel(tspan,X0_sim1,param_vals_sim1',mex_options);
        X1_ss=MEX_out1.statevalues(end,:);
        variable_values=MEX_out1.variablevalues;
        gc_profiles=variable_values(:,:);
        P21_GC_EXP(:,masterIDX)=(gc_profiles(:,ismember(VARIABLE_name,'totalp21')));


        %%%% Sim-2: Byl response of the resistant cells %%%%
        if strcmp(CellType,'resistant')
            % customization of the parental model to resistance
            X1_ss = Customization_Resistant_Model(X1_ss,STATE_names);
        end

        param_vals_sim2=param_val_ref;
        param_vals_sim2((strcmp(PARAM_name,'BYL719')))=byl_dose;
        param_vals_sim2((strcmp(PARAM_name,'BYL719_on_time')))=0;
        % Keeping Qstim ON
        param_vals_sim2((strcmp(PARAM_name,'IGF_on_time')))=0;
        param_vals_sim2((strcmp(PARAM_name,'HRG_on_time')))=0;


        MEX_out2=pi3k_networkmodel(tspan_drug,X1_ss,param_vals_sim2',mex_options);
        variable_values=MEX_out2.variablevalues;
        byl_RP=(variable_values(:,:));

        %%%% Sim-3: DMSO of the resistant cells %%%%
        param_vals_sim3=param_val_ref;
        param_vals_sim3((strcmp(PARAM_name,'BYL719')))=0;
        param_vals_sim3((strcmp(PARAM_name,'BYL719_on_time')))=0;

        param_vals_sim3((strcmp(PARAM_name,'IGF_on_time')))=0;
        param_vals_sim3((strcmp(PARAM_name,'HRG_on_time')))=0;

        MEX_out3=pi3k_networkmodel(tspan_drug,X1_ss,param_vals_sim3',mex_options);
        variable_values=MEX_out3.variablevalues;
        byl_DMSO=variable_values(:,:);


        norm_DMSO = byl_DMSO./repmat(byl_DMSO(1,:),size(byl_DMSO,1),1);
        % normalized by dummay (remove the natural effect) and compenstated
        byl_resp_master_NDMSO(:,:,masterIDX) = byl_RP./norm_DMSO;
        byl_resp_master_X(:,:,masterIDX) = byl_RP;
        byl_resp_master_DMSO(:,:,masterIDX) = byl_RP./byl_DMSO;

    catch
    end

end

% reshaping the matrix
[nrow,ncol,~]=size(byl_resp_master_NDMSO);
byl_response_ndmso=reshape(byl_resp_master_NDMSO,[nrow,ncol,n1d,n2d]);

[nrow,ncol,~]=size(byl_resp_master_X);
byl_response_X=reshape(byl_resp_master_X,[nrow,ncol,n1d,n2d]);

[nrow,ncol,~]=size(byl_resp_master_DMSO);
byl_response_dmso=reshape(byl_resp_master_DMSO,[nrow,ncol,n1d,n2d]);


[nrow,~]=size(P21_GC_EXP);
P21_GC_EXP  =reshape(P21_GC_EXP,[nrow,n1d,n2d]);


%%
My_RD={'phosphoS6','phosphoRB','totalCd'};

for ii=1:length(My_RD)
    My_RD1_idx(ii)=find(ismember(VARIABLE_name,My_RD{ii}));
    My_RD_name(ii)=VARIABLE_name(ismember(VARIABLE_name,My_RD{ii}));

end

% choose a measurment time
t_idx=find(tspan_drug==24*60);
normal_method = 1;

if normal_method == 1
    byl_response_RP_part(:,:,:)=byl_response_ndmso(t_idx,My_RD1_idx,:,:);
elseif normal_method == 2
    byl_response_RP_part(:,:,:)=byl_response_X(t_idx,My_RD1_idx,:,:);
elseif normal_method == 3
    byl_response_RP_part(:,:,:)=byl_response_dmso(t_idx,My_RD1_idx,:,:);
end



for ii=1:length(My_RD_name)

    dose_curves_byl(:,:)=byl_response_RP_part(ii,:,:);
    dose_curves_byl_norm=dose_curves_byl./repmat(dose_curves_byl(1,:),size(dose_curves_byl,1),1);
    dose_curves_byl_norm(isinf(dose_curves_byl_norm)) = NaN;

    tmp_curve(:,:)=dose_curves_byl_norm(:,:);
    tmp_curve(isinf(tmp_curve))=NaN;


    fig_2 = figure(20);
    fig_2.Position = [727   344   217   563];

    subplot(length(My_RD_name),1,ii),
    plotshaded(log10(p21_range),[nanmean((tmp_curve),2)'-nanstd((tmp_curve),0,2)'/sqrt(size(tmp_curve,2));...
        nanmean((tmp_curve),2)'+nanstd((tmp_curve),0,2)'/sqrt(size(tmp_curve,2))],rgb(col_pick));
    hold on

    subplot(length(My_RD_name),1,ii),plot(log10(p21_range),nanmean((tmp_curve),2)','Color', rgb(col_pick))
    xlabel('p21(log10)')
    ylabel(strcat(My_RD_name{ii},'(a.u.)'))
    title(strcat('Functional role p21(',CellType,')'))
    axis tight
    box off
    hold off

end



