function success = testScreen()

try
    addpath(genpath('src'))
    scrn = PsychScreen();
    WaitSecs(1);
    scrn = CloseScreen(scrn);
    scrn = PsychScreen('reversed', true);
    WaitSecs(1);
    scrn = CloseScreen(scrn);
    success = 0;
catch
    sca;
    success = 1;

end