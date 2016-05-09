
% remove problematic things from the environment, like
% the audio and any priority threads
function PsychPurge()

    Priority(0);
    sca;
    ShowCursor;
    try KbQueueRelease
    catch
        warning('Not using the keyboard')
    end
    try PsychPortAudio('Close')
    catch
        warning('No active audio device')
    end

end