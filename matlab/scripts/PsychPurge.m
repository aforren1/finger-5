
% remove problematic things from the environment, like
% the audio and any priority threads
Priority(0);
ShowCursor;

try CloseScreen(screen);
catch
    warning('Screen not open');
end

try DeleteKeyResponse(resp_device);
catch
    warning('No active response device');
end

try CloseAudio(aud);
catch
    warning('No active audio device');
end

try
    if IsOctave
        save('-mat7-binary', [filename, '_long'], 'long_data');
        save('-mat7-binary', [filename, '_summary'], 'summary_data');
    else
        save([filename, '_long'], 'long_data', '-v7');
        save([filename, '_summary'], 'summary_data', '-v7');
    end
catch
    warning('No data available!');
end
