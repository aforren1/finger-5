
function out_data = main2(exp_type, tgt_path)

    try
        addpath(genpath('matlab'));
        tgt = ParseTgt(tgt_path);
        exp = Experiment.Factory(exp_type);

        while State(exp) ~= 'endblock'
            long_data = exp.UpdateInput(resp_device, consts.using_serial);

            [exp, out_data] = exp.StateMachine(tgt, out_data);
            % lock to the refresh rate of the screen
            time_screen = FlipScreen(exp.screen, time_screen + 0.7 * Ifi(exp.screen));
        end

    catch err
        % clean up!
        rethrow(err);
    end

end
