
function out_data = main2(exp_type, tgt_path)

    try
        experiment = Experiment.Factory(exp_type);

        while State(experiment) ~= 'endblock'
            long_data = experiment.UpdateInput(resp_device, consts.using_serial);

            [experiment, out_data] = experiment.StateMachine(consts, ui, screen,...
                                                   tgt, out_data, resp_device, extra);
            % lock to the refresh rate of the screen
            time_screen = FlipScreen(screen, time_screen + 0.5 * Ifi(screen));
        end

    catch err
        % clean up!
        rethrow(err);
    end

end
