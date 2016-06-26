function success = testImages

addpath(genpath('matlab'))

    try
        
        scrn = BlamScreen;
        imgs = BlamImages(3, 'scale', 0.8, 'reversed', true);
        imgs = ImportImage(imgs, 'misc/images/hands/da.jpg', 1, scrn.window, scrn.dims(1));
        imgs = ImportImage(imgs, 'misc/images/shapes/dd.jpg', 2, scrn.window, scrn.dims(1));
        
        DrawImage(imgs, 2, scrn.window);
        Screen('Flip', scrn.window);
        
        WaitSecs(1);
        DrawImage(imgs, 1, scrn.window);
        Screen('Flip', scrn.window);
        WaitSecs(1);
        
        scrn = CloseScreen(scrn);
        success = 1;
    catch
        success = 0;
        sca;
    end

end