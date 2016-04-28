classdef ForceResponse
    properties
        calibration;
        zero_baseline; % from the countdown file
        force_min; % in newtons
        force_max;
        daq;
        volt_2_newts;
    end
    
    methods
        function obj = ForceResponse(valid_indices, varargin)
            if ~exist('valid_indices', 'var')
                error('Need valid indices!');
            end
            if ~ispc
                error('DAQ only works on Windows (barring new hardware)');
            end
            
            opts = struct('sampling_freq', 200,...
                          'force_min', 2, ...
                          'force_max', 5, ...
                          'timing_tolerance', 0.075);
            opts = CheckInputs(opts, varargin{:});
            obj.timing_tolerance = opts.timing_tolerance;
            obj.force_min = opts.force_min;
            obj.force_max = opts.force_max;
            obj.valid_indices = opts.valid_indices;
            
            daqreset;
            daqs = daqhwinfo('nidaq');
            daq_ids = daqs.InstalledBoardIds;
            if length(daq_ids) >= 1
                daq_id = daq_ids{1};
            else
                error('No NI-DAQ device available.');
            end

            obj.daq = analoginput('nidaq', daq_id);
            obj.daq.inputType = 'SingleEnded';
            
            temp_pos = [0 8 1 9 2 10 3 11 4 12]; % setup for nidaq
            valid_channels = temp_pos(valid_indices);
            addchannel(dev.daq, valid_channels);
            dev.valid_indices = valid_indices;
            
            set(obj.daq, 'SampleRate', sampling_freq);
            set(obj.daq, 'SamplesPerTrigger', 4000);
            set(obj.daq, 'TriggerType', 'Manual');
            set(obj.daq, 'BufferingMode', 'Manual');
            set(obj.daq, 'BufferingConfig', [2 2000]);
            
            obj.zero_baseline = zeros(1, length(valid_indices));
            calibration = load(fullfile('misc/calibration/cfB_2012_08_24_regress.mat'));
            dev.volt_2_newts = calibration.Volts2N(valid_indices);
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