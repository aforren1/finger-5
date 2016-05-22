function success = testKeyboardResponse

try
    addpath(genpath('src')) 
    kbrd = KeyboardResponse(7:10);
    StartKeyResponse(kbrd);
    time_ref = WaitSecs(1);
    [new_press, updated_screen_press] = CheckKeyResponse(kbrd, [0 0 0 0]);
    fprintf(['key: ', num2str(new_press(1)), '\n']);
    fprintf(['time: ', num2str(GetSecs - new_press(2)), '\n']);
    updated_screen_press
    StopKeyResponse(kbrd);
    kbrd = DeleteKeyResponse(kbrd);
    success = 0;
    
catch
    StopKeyResponse(kbrd);
    kbrd = DeleteKeyResponse(kbrd);
    success = 1;
end


end