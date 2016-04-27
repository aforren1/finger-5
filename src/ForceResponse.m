classdef ForceResponse < KeyResponse
    properties
        sampling_freq;
        calibration;
        zero_baseline; % from the countdown file
        force_min; % in newtons
        force_max;
    end
end