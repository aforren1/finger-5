function zero_volts = Countdown(screen, resp_device)

    length_countdown = 6;
    start_zero = 3;
    stop_zero = 5;
    when = GetSecs + (1:length_countdown);

    for current = 1:length_countdown

        countdown_string = ['Experiment is starting in ',...
        num2str(length_countdown - current), ' seconds. \n\n',...
        'Keep your fingers resting on the keys.'];

        DrawFormattedText(screen.window, countdown_string,...
                          'center', 'center', screen.text_colour);
        FlipScreen(screen, when(current));

    end
end
