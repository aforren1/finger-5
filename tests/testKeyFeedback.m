function success = testKeyFeedback

try
    addpath(genpath('matlab'))
    scrn = PsychScreen();
    WaitSecs(1);
    fdbk = KeyFeedback(scrn.dims(1), scrn.dims(2), 'num_boxes', 6);
    DrawOutline(fdbk, scrn.window);
    DrawFill(fdbk, scrn.window, 'blue', [0 .4 1 0 .5 .2], .7);
    Screen('Flip', scrn.window);
    WaitSecs(1);
    scrn = CloseScreen(scrn);
    scrn = PsychScreen('reversed', true);
    fdbk = KeyFeedback(scrn.dims(1), scrn.dims(2), 'num_boxes', 4, 'reversed', true);
    DrawOutline(fdbk, scrn.window);
    DrawFill(fdbk, scrn.window, 'red', [0 1 0], .3);
    DrawFill(fdbk, scrn.window, 'green', [1 0 0], -.2);
    Screen('Flip', scrn.window);
    WaitSecs(1.5);
    scrn = CloseScreen(scrn);

    success = 0;
catch
    sca;
    success = 1;

end