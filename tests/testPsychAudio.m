function success = testPsychAudio()

addpath(genpath('src'))

try
   aud = PsychAudio(3);
   FillAudio(aud, 'misc/sounds/beep.wav', 1);
   PlayAudio(aud, 1, 0);
   WaitSecs(1);
   FillAudio(aud, 'misc/sounds/smw_coin.wav', 3);
   PlayAudio(aud, 3, GetSecs + 3);
   WaitSecs(5);
   CloseAudio(aud);
   success = 1;
   
catch
    success = 0;
    try PsychPortAudio('Close');
    catch
        warning('No active audio device')
    end    

end