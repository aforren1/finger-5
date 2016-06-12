
function out_data = main2

    try
        % get important functions into memory
        WaitSecs(0.0001);
        ref_time = GetSecs; % reference for the whole block
        HideCursor;
        addpath(genpath('matlab'));

        % set up experiment
        ui = UserInputs;
        tgt = ParseTgt(Tgt(ui), ',');
        exp = Experiment.Factory(Type(ui), tgt);
        if use_serial
            TeensySetupScript;
        end
        
        while State(exp) ~= 'endblock'
            long_data = exp.UpdateInput(resp_device, working_serial);

            [exp, out_data] = exp.StateMachine(tgt, out_data);
            % lock to the refresh rate of the screen
            time_screen = FlipScreen(exp.screen, time_screen + 0.7 * Ifi(exp.screen));
        end

    catch err
        % clean up!
        rethrow(err);
    end

end
