%% Data Formatting for Model Calibration

%% to load training data set

if calib_task == 1    
    file_name   = 'Calibration_Dataset_PI3K_NetworkModel.xlsx';
    sheets      = sheetnames(file_name);    
else
    file_name   = 'Calibration_Dataset_PI3K_NetworkModel-plot.xlsx';
    sheets      = sheetnames(file_name);
end


for ii = 1:length(sheets)
    
    sheet_name = sheets{ii};
    EstimData.expt.title{ii}        = readcell(file_name,'Sheet',sheet_name,'Range','B1:B1');
    EstimData.expt.description{ii}  = readcell(file_name,'Sheet',sheet_name,'Range','B2:B2');
    EstimData.expt.source{ii}       = readcell(file_name,'Sheet',sheet_name,'Range','B3:B3');
    EstimData.expt.type{ii}         = readcell(file_name,'Sheet',sheet_name,'Range','B4:B4');
    EstimData.expt.ligand{ii}       = readcell(file_name,'Sheet',sheet_name,'Range','B5:B5');
    dat_mat = readcell(file_name,'Sheet',sheet_name,'Range','A6');
    EstimData.expt.names{ii}        = dat_mat(1,2:end);
    
    if strcmp(EstimData.expt.type{ii}{1},'dose')
        EstimData.expt.dose{ii}     = cell2mat(dat_mat(2:end,1));% (Note: dividie by 5 is only for PI3K Network model)
        % note: we assume that insulin effect is 1/5 of IGF-1
        EstimData.expt.time{ii}     = cell2mat(readcell(file_name,'Sheet',sheet_name,'Range','C4:C4')); % min
    elseif strcmp(EstimData.expt.type{ii}{1},'time')
        EstimData.expt.time{ii}     = cell2mat(dat_mat(2:end,1));
        EstimData.expt.dose{ii}     = cell2mat(readcell(file_name,'Sheet',sheet_name,'Range','C4:C4')); % min        
    end
    
    dat_exp = dat_mat(2:end,2:end);
    
    for jj = 1:size(dat_exp,2)
        EstimData.expt.data{ii}{jj}  = cell2mat(dat_exp(:,jj));
    end
    
    
end


%% model parameters
EstimData.model.paramnames          = PARAM_name;
EstimData.model.paramvals           = []; % 
EstimData.model.initialparamvals    = P0;
EstimData.model.bestfit             = [653	27.7	392	0.385	88.7	0.0113	552	0.0143	0.315	0.0076	640	935	0.154	11.1	698	1.34	8.15	0.0019	0.0031	1.03	0.316	0.219	64.1	2.54	1.07	1.8	28.7	627	215	0.289	3.72	0.157	533	22.6	0.071	0.269	462	2.05	1.5	8	0.0486	0.0069	11.6	0.541	0.0605	0.0021	39.2	348	0.0615	0.115	151	9.55	0.0619	39.1	0.0119	186	0.0035	34	0.0017	2.29	0.0042	203	4.67	31.8	0.687	0.234	0.0379	118	0.0507	2.69	0.0087	0.332	1.8	357	0.116	0.0023	14.2	0.0721	0.0078	0.0764	184	204	0.0783	0.216	70	7.52	2.88	0.124	166	1.23	0.0105	3.07	210	0.0101	16.8	0.0519	0.191	1.27	80.9	0.0023	0.0522	597	0.573	1.97	3.58	43.8	849	0.006	0.0119	71.9	12.1	4.46	3.77	141	0.511	281	0.348	0.0991	0.0841	0.175	23.1	0.0343	0.212	578	0.0019	4.92	0.515	552	43.2	323	405	0.0015	0.649	0.001	1.32	69.2	2.98	4.29	0.0796	0.229	1	1	100	2000	2000	100000	0	1	0.05	100000	0	100000	0	100000	0	100000	0	100000	0	100000	0	100000	0	100000	0	100000	0	100000	0	100000	0	100000	0	100000	0	100000	0	100000	0	100000	0	100000	0	100000	0	100000	0	100000	0	100000	0	100000	0	100000	0	100000	0];
EstimData.model.statenames          = STATE_names;
EstimData.model.initials            = X0; % y0 <= ode model
EstimData.model.varnames            = VARIABLE_name;
EstimData.model.maxnumsteps         = mex_options.maxnumsteps; 
EstimData.model.TraningMode         = 1;
EstimData.model.UseParallel         = 1;
EstimData.model.Display             = 'iter';

%% simulation data
EstimData.sim.statevalues           = [];
EstimData.sim.varvalues             = [];
EstimData.sim.resampled             = [];
EstimData.sim.simulation            = [];
EstimData.sim.J                     = [];
EstimData.sim.Jb                    = [];
EstimData.sim.ci_mask_size          = 0.25;
EstimData.sim.Jth                   = {0 0 0 0};
EstimData.sim.Jweight               = {0.5 1 1 0.5};



