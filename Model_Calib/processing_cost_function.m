Exp_Data    = EstimData.expt.data{irt}{ii};
Mask    = EstimData.sim.ci_mask_size;

% save simulaiton results
EstimData.sim.resampled{irt}{ii}    = Sim_Data;
mean_squared_error = calculation_cost_function(Sim_Data,Exp_Data,[],Mask);

[ssm, nnv]  = checking_steadystate_negative(state_vals_NR,state_vals_FR);
error_sum   = mean_squared_error + (ssm + nnv) * EstimData.model.TraningMode;
bio_error_sum   = biological_condition(var_vals_FR_sampled(:,ii)) * EstimData.model.TraningMode;

EstimData.sim.J{irt}{ii} = error_sum;
EstimData.sim.Jb{irt}{ii} = bio_error_sum;