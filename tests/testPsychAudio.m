function success = testPsychAudio

addpath(genpath('matlab'))

try
   aud = BlamAudio;
   FillAudio(aud, 'misc/sounds/beep.wav', 1, 1);
   PlayAudio(aud, 1, 0);
   WaitSecs(1);
   FillAudio(aud, 'misc/sounds/smw_coin.wav', 2, 2);
   PlayAudio(aud, 2, GetSecs + 3);
   WaitSecs(5);
   % doesn't really work in this example, but does in reality
   same_time = GetSecs + 5;
   PlayAudio(aud, 1, same_time);
   PlayAudio(aud, 2, same_time);
   CloseAudio(aud);
   success = 1;
   
catch
    success = 0;
    try PsychPortAudio('Close');
    catch
        warning('No active audio device')
    end    

end