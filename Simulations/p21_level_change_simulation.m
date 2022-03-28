%% Response of pRB, cyclin D1, pS6 to an increasing p21 expression 
% Developed: 11 Feb 2022
% Updated: 11 Feb 2022

%% LOAD THE BEST-FITTED PARAMETER SETS
%filename='Best_Fitted_Param_Sets_77.csv';
filename='Best_Fitted_Param_Sets_77_MOD_kc2_rt_020b.csv';
par_vals = csvread(filename,0,0)';

%FIT_SCORE = par_vals(1,:)';
param_sets = par_vals(2:end,:);

PARAM_table = array2table(param_sets,"RowNames",PARAM_name);
% writetable(PARAM_table,strcat(outdir,'\Best_Fitted_Params.xlsx'),"WriteVariableNames",true,"WriteRowNames",true);


%% Select a cell type to be simulated
cell_label = {'Parental','Resistant'};


%% Simulation time frame
QTime = param_sets((strcmp(PARAM_name,'IGF_on_time')),1);
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
% p21 basal level (before stimulation)

% p21_level(:,:)=P21_GC_EXP(1,:,:);
% % p21 normalized (based on the control level)
% cnt_idx=find(p21_range==1);
% p21_norm=p21_level./repmat( p21_level(cnt_idx,:),size(p21_level,1),1);


%%
% plot results

%%  main readouts of the model
% My_RD1={'phosphoS6','phosphoS6K','phosphoNDRG1','phosphoErk','phosphoAkt',...
%     'totalCd','totalp21','totalER','phosphoRB'};
% My_RD1_idx=find(ismember(VARIABLE_name,My_RD1));
% My_RD_name=VARIABLE_name(My_RD1_idx);


My_RD={'totalCd','phosphoRB','phosphoS6'};
for ii=1:length(My_RD)
    My_RD1_idx(ii)=find(ismember(VARIABLE_name,My_RD{ii}));
    My_RD_name(ii)=VARIABLE_name(ismember(VARIABLE_name,My_RD{ii}));

end

% choose a measurment time
t_idx=find(tspan_drug==24*60);

% Signal responses with different compensation method: 
% normalized to "normalized DMSO" (1),
% no Normalization (2),
% Normalized to "original DMSO"(3)
normal_method = 1;

if normal_method == 1
    byl_response_RP_part(:,:,:)=byl_response_ndmso(t_idx,My_RD1_idx,:,:);
elseif normal_method == 2
    byl_response_RP_part(:,:,:)=byl_response_X(t_idx,My_RD1_idx,:,:);
elseif normal_method == 3
    byl_response_RP_part(:,:,:)=byl_response_dmso(t_idx,My_RD1_idx,:,:);
end


%figure('Position',[307         652        1087         298])

for ii=1:length(My_RD_name)
    dose_curves_byl(:,:)=byl_response_RP_part(ii,:,:);
    dose_curves_byl_norm=dose_curves_byl./repmat(dose_curves_byl(1,:),size(dose_curves_byl,1),1);
    dose_curves_byl_norm(isinf(dose_curves_byl_norm)) = NaN;
    
    
    % [time,variables,p21,model]
    % p21_norm(:,jj)'/max(p21_norm(:,jj))
    % to cluster the response pattern
     fig_1 = figure(ii);
%     fig_1.Position = [381   578   931   314];
%     subplot(1,2,1),plot(log10(p21_range),dose_curves_byl),
%     xlabel('p21(a.u.)'),ylabel(strcat(My_RD_name{ii}))
%     title(CellType)
%     
%     subplot(1,2,2),plot(log10(p21_range),dose_curves_byl_norm)
%     xlabel('p21(a.u.)'),ylabel(strcat(My_RD_name{ii},'(normal.)'))
%     title(CellType)

    
    tmp_curve(:,:)=dose_curves_byl_norm(:,:);
    tmp_curve(isinf(tmp_curve))=NaN;
    
    
    fig_2 = figure(20);
    subplot(1,length(My_RD_name),ii),
    plotshaded(log10(p21_range),[nanmean((tmp_curve),2)'-nanstd((tmp_curve),0,2)'/sqrt(size(tmp_curve,2));...
        nanmean((tmp_curve),2)'+nanstd((tmp_curve),0,2)'/sqrt(size(tmp_curve,2))],rgb('Red'));
    hold on
    
    subplot(1,length(My_RD_name),ii),plot(log10(p21_range),nanmean((tmp_curve),2)','r')
    xlabel('p21(a.u.)'),ylabel(strcat(My_RD_name{ii},'(normal.)'))
    title(CellType)
    axis tight
    pbaspect([4 3 1])
    box off
    hold off
    
    
    sav_for_prisim=table(p21_range',nanmean((tmp_curve),2),nanstd((tmp_curve),0,2),...
        ones(size(p21_range'))*size(tmp_curve,2));
    sav_for_prisim.Properties.VariableNames = {'p21','mean','std','num'};
    
    sav_data = array2table(...
        [p21_range'...
        nanmean(dose_curves_byl_norm,2)...
        nanstd(dose_curves_byl_norm,0,2)/sqrt(size(dose_curves_byl_norm,2))...
        ones(size(p21_range'))*size(dose_curves_byl_norm,2)],...
        'VariableNames',{'p21','Mean','SD','Num'});
    
    file_name = strcat(workdir,'\Outcome\','p21KDnOE_',CellType,'.xlsx');
    sheet_name = strcat(My_RD_name{ii},'_',num2str(normal_method)); 

    
    writetable(sav_data,file_name,'WriteRowNames',false,'WriteVariableNames',false,...
        'Sheet',sheet_name,...
        'WriteVariableName',false)
end

fname_fig_2 = strcat(workdir,'\Outcome\',strcat('Signal Response to p21 expression_',CellType,'.jpeg'));
saveas(fig_2,fname_fig_2)


