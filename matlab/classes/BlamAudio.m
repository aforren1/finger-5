classdef BlamAudio

    properties
        pamaster;
        sound_handle;
        which_audio_fun;
    end
    
    methods
        function obj = BlamAudio
            try PsychPortAudio('Close');
            catch
                warning('No active audio device')
            end
            InitializePsychSound(1);
            
            % set sound reading function
            % octave classes and function handles are weird for now, so wait
            % until FillAudio to figure out the *actual* function
            if IsOctave || verLessThan('matlab', '8')
                obj.which_audio_fun = 'wavread';
            else
                obj.which_audio_fun = 'audioread';
            end
            
            % open in master mode with low latency (other audio devs may fail)
            obj.pamaster = PsychPortAudio('Open', [], 9, 2, 44100, 2);
            PsychPortAudio('Start', obj.pamaster, 0, 0, 1);
            obj.sound_handle = zeros(1, 1000);
        end % end constructor
        
        function FillAudio(obj, file_or_matrix, aud_index, mono_stereo)
        % obj is the object of BlamAudio class 
        % file_or_matrix is the complete path to the audio file (or an existing matrix)
        % aud_index is the index of the slave to fill
		% if mono_stereo = 0, then stereo
		% if mono_stereo = 1, then left
		% if = 2, then right
            if ischar(file_or_matrix)
                if strcmpi(obj.which_audio_fun, 'wavread')
                    audio_fun = @wavread;
                elseif strcmpi(obj.which_audio_fun,  'audioread')
                    audio_fun = @audioread;
                else
                    error('No good audio reading function (??)')
                end
                snd = audio_fun(file_or_matrix); % read sound w/ wavread or audioread
            elseif ismatrix(file_or_matrix)
                snd = file_or_matrix;
            else
                error('No recognized type for file_or_matrix')
            end
			
			% make sure matrix is oriented correctly
			if size(snd, 1) > size(snd, 2)
                snd = snd';
            end
			
			if mono_stereo == 0
			    obj.sound_handle(aud_index) = PsychPortAudio('OpenSlave', obj.pamaster, 1);
				% looking for a 2xn matrix, duplicate channel if mono    		
				if size(snd, 1) < 2
					snd = [snd; snd];
				end

			elseif mono_stereo == 1	|| mono_stereo == 2
                if size(snd, 1) > 1
                     warning('Shoving a stereo sound into mono, be aware!');
                     snd = snd(:, 1) + snd(:, 2);
                end				 
				obj.sound_handle(aud_index) = PsychPortAudio('OpenSlave', obj.pamaster, 1, 1, mono_stereo);
			else
			    error('Unrecognized setting for audio channel')
		    end
			
            PsychPortAudio('CreateBuffer', aud_index, snd);
            PsychPortAudio('FillBuffer', aud_index, snd);
        end
        
        function out_time = PlayAudio(obj, aud_index, time)
            out_time = PsychPortAudio('Start', aud_index, 1, time, 1);
        end
        
        function StopAudio(obj, aud_index)
            PsychPortAudio('Stop', aud_index);
        end
        
        function CloseAudio(obj)
            PsychPortAudio('Close');
        end
    
    end

end