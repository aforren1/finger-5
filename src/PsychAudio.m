classdef PsychAudio

    properties
        pamaster;
        sound_handle;
        soundfun;
    end
    
    methods
        function obj = PsychAudio(n_channels)
            try PsychPortAudio('Close');
            catch ME
                warning('No active audio device')
            end
            InitializePsychSound(1);
            
            % set sound reading function
            if (exist('OCTAVE_VERSION', 'builtin') || verLessThan('matlab', '8'))
                soundfun = @wavread;
            else
                soundfun = @audioread;
            end
            
            % open in master mode with low latency (other audio devs may fail)
            obj.pamaster = PsychPortAudio('Open', [], 9, 2, 44100, 2);
            PsychPortAudio('Start', pamaster, 0, 0, 1);
            obj.sound_handle = zeros(1, n_channels);
            for ii = 1:n_channels
                obj.sound_handle(ii) = PsychPortAudio('OpenSlave', pamaster, 1);
            end
        end % end constructor
        
        function FillAudio(obj, file_path, idx)
            snd = obj.soundfun(file_path); % read sound w/ wavread or audioread
            PsychPortAudio('CreateBuffer', idx, temp);
            PsychPortAudio('FillBuffer', idx, temp);
        end
        
        function PlayAudio(obj, idx, time)
            PsychPortAudio('Start', idx, 1, time, 0);
        end
        
        function StopAudio(obj, idx)
            PsychPortAudio('Stop', idx);
        end
        
        function CloseAudio()
            PsychPortAudio('Close');
        end
    
    end

end