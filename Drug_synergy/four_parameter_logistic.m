function data_fit  = four_parameter_logistic(data_fit)


dat_arry_1      = data_fit.data;
dose_range_log  = data_fit.dose_range;
% info for fitting
min_dose        = abs(min(dose_range_log));
% shift x-axis (starting at 0)
dose_range_x0   =dose_range_log + min_dose;
dat_arry_2      =dat_arry_1/max(dat_arry_1);



if strcmp(data_fit.type,'negative')
    % antagonist
    ft  = '(ymax-ymin)/(1+(x/ic50)^h1)+ymin';
    f1  = fittype(ft,'coefficients',{'ymax','ymin','ic50','h1'});
elseif strcmp(data_fit.type,'positive')
    % agonist
    ft  = 'ymax*x^h1/(ic50^h1+x^h1)+ymin';
    f1  = fittype(ft,'coefficients',{'ymax','ymin','ic50','h1'});
end


% test
% plot(dose_range_tform,curve_cut_off)


h_arry = [2 1/2 4 1/4 5 1/5];
max_fail=5;

for ii = 1 : max_fail
        
    % initial guesses
    ymax_0 = max(dat_arry_2);
    ymin_0 =min(dat_arry_2);
    h1_0 = 2*h_arry(ii);
    
    try
        % estimate ic50 values
        if strcmp(data_fit.type,'negative')
            
            ic50_0  = dose_range_x0(dat_arry_2/max(dat_arry_2)<0.5);
            
            [fitobject,gof] = fit(dose_range_x0',dat_arry_2,f1,...
                'StartPoint',[ymax_0, ymin_0, ic50_0(1), h1_0]);
            
        elseif strcmp(data_fit.type,'positive')
            ic50_0=dose_range_x0(dat_arry_2/max(dat_arry_2)>0.5);
            
            [fitobject,gof] = fit(dose_range_x0',dat_arry_2,f1,...
                'StartPoint',[ymax_0, ymin_0, ic50_0(1), h1_0]);
        end
        
        % ic50 of drug (readouts, drugs, models)
        data_fit.ic50   = 10^(fitobject.ic50 - min_dose);
        data_fit.h1     = fitobject.h1;
        data_fit.r2     = gof.rsquare;
        
        
        % stop abd exist if it is successful at the first trial
        break;   
                
        if gof.rsquare < 0.9
            error('poor fitting')
        end
        
        
    catch
        if ii == max_fail
            data_fit.ic50 = NaN;
            data_fit.h1 = NaN;
            data_fit.r2=NaN;
        end
    end
end




% for test
% plot(dose_range_log,del_x_trunc)
%
