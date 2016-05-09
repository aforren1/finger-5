classdef KeyboardResponse
    properties
        timing_tolerance;
        valid_indices;
        valid_keys;
        force_min;
        force_max;
    end
    
    methods
        function obj = KeyboardResponse(valid_indices, varargin)
            if ~exist('valid_indices', 'var')
                error('Need valid indices!');
            end
            
            opts = struct('possible_keys', {{'a','w','e','f','v','b','h','u','i','l'}},...
                          'timing_tolerance', 0.075,...
                          'force_min', 1,...
                          'force_max', 100);
            opts = CheckInputs(opts, varargin{:});
            obj.timing_tolerance = opts.timing_tolerance;
            obj.force_min = opts.force_min;
            obj.force_max = opts.force_max;
            obj.valid_keys = opts.possible_keys(valid_indices);
            obj.valid_indices = valid_indices;
            
            keys = zeros(1, 256);
            keys(KbName(obj.valid_keys)) = 1;
            KbQueueCreate(-1, keys);   
        end      
        
        function StartKeyResponse(obj)
            KbQueueStart;
        end
        
        function StopKeyResponse(obj)
            KbQueueStop;
        end
        
        function obj = DeleteKeyResponse(obj)
            try 
                KbQueueRelease;
            catch
                warning('Not using the keyboard')
            end
            obj = [];
        end
        
        function [new_press, updated_screen_press] = CheckKeyResponse(obj, updated_screen_press)
        
            [~, pressed, released] = KbQueueCheck;
            if any(pressed > 0)
                press_key = KbName(find(pressed > 0));
                if iscell(press_key)
                    press_key = cell2mat(press_key);
                end
                
                new_screen_press = ismember(obj.valid_keys, press_key); % for updated feedback
                updated_screen_press = updated_screen_press + new_screen_press;
                press_index = find(new_screen_press);
                time_press = min(pressed(pressed > 0));
                new_press = [press_index, time_press];
            else % no new presses
                new_press = [NaN, NaN];
            end
            
            if any(released > 0) % figure out if any keys have been released in the frame
                release_key = KbName(find(released > 0));
                new_screen_release = ismember(obj.valid_keys, release_key);
                updated_screen_press = updated_screen_press - new_screen_release;
                release_index = find(new_screen_release);
                time_release = min(released(released > 0));
                new_release = [release_index, time_release];
            else
                new_release = [NaN, NaN];       
            end   
            KbQueueFlush;       
        end % end CheckKeyResponse
        
    end % end methods
end % end classdef