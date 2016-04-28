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
            keys = zeros(1, 256);
            keys(KbName(obj.valid_keys)) = 1;
            KbQueueCreate(-1, keys);   
        end      
        
        function DeleteKeyResponse(obj)
            try 
                KbQueueRelease;
            catch
                warning('Not using the keyboard')
            end
        end
    end
end