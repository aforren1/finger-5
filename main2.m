
function out_data = main2

    try
        % get important functions into memory
        WaitSecs(0.0001);
        HideCursor;
        ref_time = GetSecs; % reference for the whole block
        addpath(genpath('matlab'));

        % set up experiment
        ui = UserInputs;
        tgt = ParseTgt(ui.tgt_name);
        exp = Experiment.Factory(exp_type);
        if use_serial
            if isunix
                src_path = ['"$(pwd)/platformio/', ui.exp_type,'_src"'];
            else
                src_path = ['%cd%\platformio\', ui.exp_type, '_src'];
            end
            setenv('PLATFORMIO_SRC_DIR', src_path);
            system('platformio run --target clean -v');
            working_serial = ~system('platformio run -e teensy31 -v');
            working_serial = ~system('platformio run -e teensy31 --target upload -v');
            if ~working_serial
                warning('Teensy failed for some reason (printed above?)!');
                warning('Will ignore the serial port in the experiment...');
            end
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
