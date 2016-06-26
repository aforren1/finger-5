function success = testScreen()

try
    addpath(genpath('matlab'))
    scrn = BlamScreen();
    WaitSecs(1);
    scrn = CloseScreen(scrn);
    scrn = BlamScreen('reversed', true);
    WaitSecs(1);
    scrn = CloseScreen(scrn);
    success = 0;
catch
    sca;
    success = 1;

end