
function long_data = main2(tgt_name)

    try
        % get important functions into memory
        WaitSecs(0.0001);
        ref_time = GetSecs; % reference for the whole block
        HideCursor;
        addpath(genpath('matlab'));

        % set up experiment
        ui = UserInputs;
        % hack to override the tgt selection
        if nargin == 1
            ui.tgt = ['misc/tfiles/', tgt_name];
            tmp = strsplit(tgt_name, '_');
            ui.exp_type = tmp{1};
        end
        tgt = ParseTgt(Tgt(ui), ',');

        exp = Experiment.Factory(Type(ui), tgt);
        if use_serial
            TeensySetupScript;
        end

        while State(exp) ~= 'endblock'
            [long_data, summary_data] = exp.StateMachine(tgt, long_data, summary_data);
            % lock to the refresh rate of the screen
            time_screen = FlipScreen(exp.screen, time_screen + 0.7 * Ifi(exp.screen));
        end

    catch err
        % clean up!
        rethrow(err);
    end

end
