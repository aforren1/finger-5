function u_s_p = RapidPenalty(screen, resp_device, tgt, images,...
                              press_feedback, u_s_p, ii)
                              

    WipeScreen(screen);
    DrawOutline(press_feedback, screen.window);
    DrawFill(press_feedback, screen.window, 'red', u_s_p, 0); 
    DrawImage(images, tgt.image_index(ii), screen.window);                             
    FlipScreen(screen);
    
    WaitSecs(1);
    
    WipeScreen(screen);
    DrawOutline(press_feedback, screen.window);
    DrawImage(images, tgt.image_index(ii), screen.window);
    FlipScreen(screen);
    u_s_p = zeros(1, length(resp_device.valid_indices));  
    CheckKeyResponse(resp_device, u_s_p); % dump recent data?
                              
end
