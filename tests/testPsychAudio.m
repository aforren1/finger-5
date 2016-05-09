function success = testPsychAudio()

addpath src

try
   aud = PsychAudio(3);
   FillAudio(aud, 'misc/sounds/beep.wav', 1);
   PlayAudio(aud, 1, 0);
   WaitSecs(1);
   CloseAudio(aud);
      success = 1;
   
catch
    success = 0;
    try PsychPortAudio('Close');
    catch
        warning('No active audio device')
    end    

end