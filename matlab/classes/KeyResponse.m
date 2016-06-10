% superclass for keyboard-like response objects
classdef KeyResponse
    properties
        valid_indices; 
        timing_tolerance; % how close to a beep counts as good
    end
    
    methods
        function obj = KeyResponse(valid_indices, varargin)
            if exist('valid_indices', 'var')
                obj.valid_indices = valid_indices;
            else
                warning('No valid indices specified, initializing empty!');
                obj.valid_indices = [];
            end
            opts = struct('timing_tolerance', 0.075);
            opts = CheckInputs(opts, varargin{:});
            obj.timing_tolerance = opts.timing_tolerance;
        end
    end
end
