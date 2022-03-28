function [Obj,EstimData]=GA_User_Code(PX0,EstimData,target_param_index)

% taking over the parameter values
paramvals=EstimData.model.bestfit;

% UPDATE TARGETED PARAM VALUES
if ~isempty(target_param_index)
    paramvals(target_param_index)=10.^round(PX0,2);
    EstimData.model.paramvals=paramvals;
else % IF THERE IS NO TARGETED PARAM (FOR POST-PROCESSING)
    EstimData.model.paramvals=EstimData.model.bestfit;
end


% Calculation of errror between simulation and experiment
for ii=1:4
    EstimData=Cost_Function(EstimData,ii);
end


%% weighting J Jw(i)= J(i)^2/sum(J)

% find the simulated data
jindex = find(~cellfun(@isempty,EstimData.sim.J));

try
    for ii = 1:length(jindex)        
        kk = jindex(ii);
        % sum up J
        obj_subtotal=sum(cellfun(@sum,EstimData.sim.J{kk}));
        
        for jj=1:length(EstimData.sim.J{kk})
            % % to excelerate the training
            obj_scaled{kk}{jj}=EstimData.sim.J{kk}{jj}^2/obj_subtotal;
        end
        
        obj_total = sum(cellfun(@sum,obj_scaled{kk}));
        
        J_ii(kk)=obj_total*EstimData.sim.Jweight{kk};
        Jb_ii(ii)=sum(cellfun(@sum,EstimData.sim.Jb{kk}));
        
    end
    
    % to excelerate the training
    J=sum(J_ii.^2/sum(J_ii));
    Jb=sum(Jb_ii);
    
catch ME
    disp(ME.message)
    
    J = NaN;
    Jb = NaN;
end

if (J < 0) || (Jb < 0)
    Obj = NaN;
else
    Obj = J+Jb*1000;
end





