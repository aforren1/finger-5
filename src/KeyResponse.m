% superclass for keyboard-like response objects
classdef KeyResponse
    properties
        valid_indices; 
        press_tolerance; % how close to a beep counts as good
        p1;
    end
    
    methods
        function obj = KeyResponse(valid_indices, press_tolerance,...
                                   varargin)
            opts = struct('p1', 33);
            opts = CheckInputs(opts, varargin{:});
            obj.p1 = ops.p1;
            obj.valid_indices = valid_indices;
            obj.press_tolerance = press_tolerance;
        end
    end
end