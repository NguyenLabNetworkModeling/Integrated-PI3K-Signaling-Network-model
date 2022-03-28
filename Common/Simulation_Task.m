
switch Sim_Task_selection

    case 'model_calib'

        list_Simulation = {            
            'plot fitting results (training data)';
            };

        msg = 'please select a simulation task from the list\n';

        [ xx ] = readInput( list_Simulation, msg);
        sim_selection = list_Simulation{xx};

        workdir = strcat(rootwd,'\Model_Calib');
        mkdir(workdir,'Outcome')
        addpath(genpath(workdir));


        switch sim_selection

            case  'plot fitting results (training data)'

                plot_fitting_results

            case 'plot validation (full medium)'

                plot_validation_full_medium

        end



    case 'simulation'

        workdir = strcat(rootwd,'\Simulations');
        mkdir(workdir,'Outcome')
        addpath(genpath(workdir));


        list_Simulation = {
            'functional role of p21';
            'ensemble simulation';
            'model_valid_byl';
            };

        msg = 'please select a simulation task from the list\n';

        [ xx ] = readInput( list_Simulation, msg);
        sim_selection = list_Simulation{xx};



        switch sim_selection

            case 'functional role of p21'


                list_Cell = {
                    'parental';
                    'resistant';
                    };

                msg = 'Please, select a cell type from the list: \n';

                [ xx ] = readInput( list_Cell,msg);
                CellType = list_Cell{xx};

                p21_level_change_simulation

            case 'ensemble simulation'

                drug_response_ensemble_simulation;

            case 'model_valid_byl'

                run_model_validation_byl_response;

        end

    case 'drug_synergy'
        %% Drug synergy

        % simulaiton options of drug synergy
        % drug_synergy_opt.simulation: simulaiton jobs
        % drug_synergy_opt.cell: cell types (parental and resistant)
        % drug_synergy_opt.General :  readouts

        % defalt option
        drug_synergy_opt.cell          = 1;
        drug_synergy_opt.General       = 1;


        workdir = strcat(rootwd,'\Drug_synergy');
        mkdir(workdir,'Outcome')
        addpath(genpath(workdir));

        %         prompt = strcat('(1) simulate drug responses \n(2) calculate ic50 \n(3) simulate icx responses \n(4) calculate CDI \n', ...
        %             '(5) simulate icx responses (perturbation) \n(6) calculate CDI (perturbation) \n');

        msg = 'Please, select a simulation task from the list: \n';

        list_Simulation = {
            'simulate drug responses';
            'calculate ic50';
            'simulate icx responses';
            'calculate CDI';
            'simulate icx responses (perturbation)';
            'calculate CDI (perturbation)'
            };


        [ xx ] = readInput( list_Simulation,msg);
        sim_selection = list_Simulation{xx};

        %         [ drug_synergy_opt.simulation ] = readInput( list_Simulation );
        switch sim_selection

            case {'simulate drug responses';
                    'calculate ic50';
                    'simulate icx responses';
                    'calculate CDI';
                    }


                list_Cell = {
                    'parental model';
                    'resistant model';
                    };

                msg = 'Please, select a cell type from the list: \n';

                [ drug_synergy_opt.cell ] = readInput( list_Cell,msg);


                list_Option_Readouts = {
                    'only for pRB and Cyclin D1';
                    'General Readouts';
                    };

                msg = 'Please, select one from the list: \n';

                [ drug_synergy_opt.General ] = readInput( list_Option_Readouts,msg);

        end


        switch sim_selection


            case  'simulate drug responses'


                if drug_synergy_opt.cell == 1

                    drug_responses_simulation_parental

                elseif drug_synergy_opt.cell == 2

                    drug_responses_simulation_resistant
                end


            case 'calculate ic50'

                estimation_ic50_values


            case 'simulate icx responses'

                if drug_synergy_opt.cell == 1

                    if drug_synergy_opt.General == 1

                        drug_response_ICX_parental

                    elseif   drug_synergy_opt.General == 2

                        drug_response_ICX_parental_general

                    end

                elseif drug_synergy_opt.cell == 2

                    if drug_synergy_opt.General == 1

                        drug_response_ICX_resistant

                    elseif   drug_synergy_opt.General == 2

                        drug_response_ICX_resistant_general

                    end
                end



            case 'calculate CDI'

                if drug_synergy_opt.General == 1

                    calculate_drug_synergy

                    plot_synergy_score

                elseif   drug_synergy_opt.General == 2


                    calculate_drug_synergy_general

                    plot_synergy_score_general

                end

            case 'simulate icx responses (perturbation)'

                drug_response_ICX_parental_perturb

            case 'calculate CDI (perturbation)'

                calculate_drug_synergy_perturb

                plot_synergy_score_perturb

        end

end



