
% remove problematic things from the environment, like
% the audio and any priority threads
Priority(0);
ShowCursor;

try screen = CloseScreen(screen);
catch
    warning('Screen not open');
end

try DeleteKeyResponse(resp_device);
catch
    warning('No active response device');
end

try PsychPortAudio('Close');
catch
    warning('No active audio device');
end

try
    if IsOctave
        save('-mat7-binary', filename, 'output');
    else
        save(filename, 'output', '-v7');
    end
catch
    warning('No data available!');
end

