% superclass for keyboard-like response objects
classdef KeyResponse
    properties
        valid_indices; 
        timing_tolerance; % how close to a beep counts as good
        p1;
    end
    
    methods
        function obj = KeyResponse(valid_indices, timing_tolerance,...
                                   varargin)
            opts = struct('p1', 33);
            opts = CheckInputs(opts, varargin{:});
            obj.p1 = opts.p1;
            obj.valid_indices = valid_indices;
            obj.timing_tolerance = timing_tolerance;
        end
    end
end
