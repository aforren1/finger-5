classdef ForceResponse
    properties
        sampling_freq;
        calibration;
        zero_baseline; % from the countdown file
        force_min; % in newtons
        force_max;
    end
    
    methods
        function obj = ForceResponse(valid_indices, varargin)
        
        end
        
        function StartKeyResponse(obj)
        end
        
        function StopKeyResponse(obj)
        end
        
        function DeleteKeyResponse(obj)
        end
        
        function [new_press, updated_screen_press] = CheckKeyResponse(obj, updated_screen_press)
        end
        
    end % end methods
    
end % end classdef