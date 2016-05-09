function success = testImages

addpath src

    try
        
        scrn = PsychScreen;
        imgs = PsychImages(3);
        imgs = ImportImages(imgs, 'misc/images/hands/da.jpg', 1, scrn.window, scrn.dims(1));
        imgs = ImportImages(imgs, 'misc/images/shapes/dd.jpg', 2, scrn.window, scrn.dims(1));
        
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