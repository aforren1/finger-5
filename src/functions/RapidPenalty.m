function u_s_p = RapidPenalty(screen, resp_device, tgt, images,...
                              press_feedback, u_s_p, ii)
                              

    WipeScreen(screen);
    DrawOutline(press_feedback, screen.window);
    DrawFill(press_feedback, screen.window, 'red', u_s_p, 1); 
    DrawImage(images, tgt.image_index(ii), screen.window);                             
    FlipScreen(screen);
    
    WaitSecs(1);
    % record, but ignore, button presses (still needs plumbing)
    % penalty_start = GetSecs;
    % while GetSecs < penalty_start + 1
    %     updated_screen_press = zeros(1, length(resp_device.valid_indices));
    %     temp_out = CheckKeyResponse(resp_device, updated_screen_press);
    %     if temp_out(1) > 0
    %         junk = temp_out;
    %     end
    % end
    %
    
    WipeScreen(screen);
    DrawOutline(press_feedback, screen.window);
    DrawImage(images, tgt.image_index(ii), screen.window);
    u_s_p = zeros(1, length(resp_device.valid_indices));  
    CheckKeyResponse(resp_device, updated_screen_press); % dump recent data?
                              
end
