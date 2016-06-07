
function out_data = main2(exp_type)

    experiment = Experiment.Factory(exp_type);

    % fragile, how to deal with optional outputs??
    [consts, ui, screen, tgt, out_data, extra] = experiment.LoadResources();

    while State(experiment) ~= 'endblock'

        [experiment, out_data] = experiment.StateMachine(consts, ui, screen,...
                                               tgt, out_data, extra);
        % lock to the refresh rate of the screen
        time_screen = FlipScreen(screen, time_screen + 0.5 * Ifi(screen));
    end

end
