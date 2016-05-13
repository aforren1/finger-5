function success = testForceResponse

if ~ispc
    error('Windows only for now!');
end

try
    addpath src
    kbrd = ForceResponse(7:10);
    StartKeyResponse(kbrd);
    updated_screen_press = [0 0 0 0];
    scrn_press_mat = nan(4, 50);
    
    for ii = 1:50
        [new_press, updated_screen_press] = CheckKeyResponse(kbrd, updated_screen_press);
        if ~isnan(new_press(1))
            disp(new_press)
        end
        scrn_press_mat(:, ii) = updated_screen_press;
        WaitSecs(.01);
    end
    StopKeyResponse(kbrd);
    kbrd = DeleteKeyResponse(kbrd);
    disp(scrn_press_mat);
    success = 0;
    
catch
    StopKeyResponse(kbrd);
    kbrd = DeleteKeyResponse(kbrd);
    success = 1;
end