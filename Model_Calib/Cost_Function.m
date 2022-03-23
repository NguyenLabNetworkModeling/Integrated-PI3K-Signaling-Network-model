%% Cost-function

function EstimData=Cost_Function(EstimData,irt)

% load all related values (information)
paramnames  = deblank(EstimData.model.paramnames);
paramvals   = EstimData.model.paramvals;
StimOn      = paramvals(strcmp(paramnames,'IGF_on_time'));
x0s         = EstimData.model.initials;
options.maxnumsteps = EstimData.model.maxnumsteps;
statenames  = EstimData.model.statenames;

% sampling time point, simulation time, dosage
Time(1,:)   = EstimData.expt.time{irt};
tspan       = sort(unique([StimOn Time+StimOn linspace(0,StimOn+max(Time),200)]));
Dose        = EstimData.expt.dose{irt};


% readouts (e.g., pp_ERK, pp_AKT)
for ii = 1:length(EstimData.expt.names{irt})
    readout     = EstimData.expt.names{irt}{ii};
    readout_idx(ii) = find(ismember(EstimData.model.varnames,readout));
end

%% times before/after triggering stimulation
Qstim_idx   = tspan >= StimOn;
Qstim_tspan = tspan(Qstim_idx)-StimOn;
Time_idx  = ismember(Qstim_tspan,Time);



%% ODE solver (MEX)
for ii=1:length(Dose)
    
    
    x0s(strcmp(statenames,EstimData.expt.ligand{irt}))=Dose(ii);
    
    try
        % MEX output
        MEX_output  = pi3k_networkmodel(tspan,x0s,paramvals',options);
        statevalues     = MEX_output.statevalues;
        variablevalues  = MEX_output.variablevalues;
        
    catch
        MEX_output  = pi3k_networkmodel(tspan);
        statevalues     = MEX_output.statevalues * NaN;
        variablevalues  = MEX_output.variablevalues * NaN;
        
    end
    
    state_vals_NR   = statevalues(~Qstim_idx,:);
    state_vals_FR   = statevalues(Qstim_idx,:);
    var_vals_FR     = variablevalues(Qstim_idx,:);
    
    var_vals_FR_sampled(:,:,ii)=var_vals_FR(Time_idx,readout_idx);
    %var_vals_FR_sampled(:,:,ii)=state_vals_FR;
    
end


% initialize variables
EstimData.sim.J{irt}    = [];
EstimData.sim.resampled{irt} = [];



%% RESAMPLING AND CALCULATION OF ERROR

% FOR EACH READOUT
for ii=1:length(EstimData.expt.data{irt})
    
    if strcmp(EstimData.expt.type{irt},'dose')
        
        Sim_Data(:,1)   = var_vals_FR_sampled(1,ii,:);
        processing_cost_function
        
        
    elseif strcmp(EstimData.expt.type{irt},'time')
        
        Sim_Data(:,1)=var_vals_FR_sampled(:,ii,1);
        processing_cost_function
        
    end
    
end




