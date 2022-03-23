


switch jobcode    
    
    case 'model_calib'
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        prompt = 'choose a task :  \n (1) run GA \n (2) plot fitting results (training data)  \n (3) plot validation (full medium)  \n';
        xx = input(prompt);
        calib_task = xx;
        
        workdir = strcat(rootwd,'\Model_Calib');
        mkdir(workdir,'Outcome')
        addpath(genpath(workdir));
        
        
        if xx == 1
            disp([' ==> [run GA] selected',newline])
            
            % run GA code
            Run_Genetic_Algorithm
            
        elseif xx == 2
            
            disp([' ==> [plot fitting results (training data)] selected',newline])
            
            plot_fitting_results
                        
        elseif xx == 3
            
            disp([' ==> [plot validation (full medium)] selected',newline])
            
            plot_validation_full_medium
            
        end
        
        %
        %
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'simulation'
        
        
        workdir = strcat(rootwd,'\Simulations');
        mkdir(workdir,'Outcome')
        addpath(genpath(workdir));
        
        
        
        prompt = 'what is a simulation task:  \n (1) functional role of p21, \n (2) ensemble simulation,  \n (3) model_valid_byl  \n';
        xx = input(prompt);
        
        if xx == 1
            disp([' ==> functional role of p21 selected',newline])
            
            prompt = 'what is a cell type: \n (1) parental, \n (2) resistant cell \n';
            CellType = input(prompt);
            
            if CellType == 1
                disp([' ==> parental cells selected',newline])
            elseif CellType == 1
                disp([' ==> parental cells selected',newline])
            end
            
            p21_level_change_simulation
            
        elseif xx == 2
            disp([' ==> ensemble simulation selected',newline])
            drug_response_ensemble_simulation;
            
            
        elseif xx == 3
            disp([' ==> model_valid_byl selected',newline])
            run_model_validation_byl_response;
        end
        
        %
        %
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'id_test'
        
        workdir = strcat(rootwd,'\Identifiability_test');
        mkdir(workdir,'Outcome')
        addpath(genpath(workdir));
        
        
        
        prompt = 'what is a simulation task: \n (1) run_identifiability, \n (2) run_sensitivity, \n (3) process_identifiability, \n (4) process_sensitivity  \n';
        xx = input(prompt);
        
        if xx == 1
            disp([' ==> run_identifiability selected',newline])
            Run_Identifiability
            
        elseif xx == 2
            disp([' ==> run_sensitivity selected',newline])
            Run_Sensitivity_Test
            
        elseif xx == 3
            disp([' ==> process_identifiability selected',newline])
            Processing_identifiability_Result
            
        elseif xx == 4
            disp([' ==> process_sensitivity selected',newline])
            Processing_Sensitivity_Result
        end
        
        %
        %
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'drug_synergy'
        %% Drug synergy
        
        % simulaiton options of drug synergy
        % DS_option.simulation: simulaiton jobs
        % DS_option.cell: cell types (parental and resistant)
        % DS_option.General :  readouts

        % defalt option        
        DS_option.cell          = 1;
        DS_option.General       = 1;
                
        
        workdir = strcat(rootwd,'\Drug_synergy');
        mkdir(workdir,'Outcome')
        addpath(genpath(workdir));
        
        
        prompt = strcat('(1) simulate drug responses \n(2) calculate ic50 \n(3) simulate icx responses \n(4) calculate CDI \n', ...
            '(5) simulate icx responses (perturbation) \n(6) calculate CDI (perturbation) \n');
        DS_option.simulation = input(prompt);
        
        if DS_option.simulation <=4
            prompt = ' what is a model type? \n (1) parental model  \n (2) resistan model \n';
            DS_option.cell = input(prompt);
            
            prompt = ' drug synergy for General Variables \n (0) no  \n (1) yes \n';
            DS_option.General = input(prompt);
        end
        
        
        if   DS_option.simulation == 1
            %% Simulate Drug Response
            disp([' ==> simulate drug responses selected',newline])
            
            if DS_option.cell == 1
                disp([' ==> parental model selected',newline])
                
                drug_responses_simulation_parental
            elseif DS_option.cell == 2
                disp([' ==> resistant model selected',newline])
                
                drug_responses_simulation_resistant
            end
            
            
        elseif DS_option.simulation == 2
            %% Calculate IC50
            
            disp([' ==> calculate ic50 selected',newline])
            estimation_ic50_values
            
            
            
        elseif DS_option.simulation == 3
            %% Simulate ICX response
            
            disp([' ==> simulate icx responses selected',newline])
            
            if DS_option.cell == 1
                disp([' ==> parental model selected',newline])
                
                if DS_option.General == 0
                    drug_response_ICX_parental
                elseif   DS_option.General == 1
                    disp([' ==> drug synergy for pS6 selected',newline])
                    drug_response_ICX_parental_general
                end
                
            elseif DS_option.cell == 2
                disp([' ==> resistant model selected',newline])
                
                if DS_option.General == 0
                    drug_response_ICX_resistant
                    
                elseif   DS_option.General == 1
                    disp([' ==> drug synergy for pS6 selected',newline])
                    drug_response_ICX_resistant_general
                end
            end
            
            
            
        elseif DS_option.simulation == 4
            %% Calculate Drug Synergy
                        
            disp([' ==> calculate CI selected',newline])
            
            
            if DS_option.General == 0
                
                calculate_drug_synergy
                plot_synergy_score
                
            elseif   DS_option.General == 1
                disp([' ==> drug synergy for General Variables selected',newline])
                
                calculate_drug_synergy_general
                plot_synergy_score_general
                
            end
            
        elseif DS_option.simulation == 5
            disp([' ==> [simulate icx responses (perturbation)] selected',newline])
                        
            drug_response_ICX_parental_perturb
            
        elseif DS_option.simulation == 6
            disp([' ==> [calculate CI (perturbation)] selected',newline])
            
            
             
              calculate_drug_synergy_perturb
              plot_synergy_score_perturb
                
                
        end
        
             
        
        %
        %
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
end



