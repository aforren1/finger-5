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
            obj.volt_2_newts = calibration.Volts2N(valid_indices);
        end
        
        function StartKeyResponse(obj)
            stop(obj.daq);
            start(obj.daq);
            trigger(obj.daq);
        end
        
        function StopKeyResponse(obj)
            stop(obj.daq);
        end
        
        function obj = DeleteKeyResponse(obj)
            delete(obj.daq);
            obj = [];
        end
        
        function [new_press, updated_screen_press] = CheckKeyResponse(obj, updated_screen_press, previous_state)
            while(isempty(new_screen_press))
                new_screen_press = getsample(obj.daq);
            end
            time_press = GetSecs;
            % rescale output
            new_screen_press = new_screen_press - obj.zero_baseline;
            new_screen_press = new_screen_press .* obj.volt_2_newts;
            new_screen_press_scaled = new_screen_press / obj.force_min;
            % bound the screen press 
            update_screen_press(update_screen_press > 1) = 1;
            update_screen_press(update_screen_press < 0) = 0;
            % make sure to check n and n-1 conditions
            delta_press = updated_screen_press - previous_state;
            press_index = find(delta_press == 1);
            release_index = find(delta_press == -1);
            
            new_press = [press_index, time_press];
            new_release = [release_index, time_press];
            
        end
        
        % todo: rename to something better
        function [force_traces, timestamp] = CheckFullResponse(obj)
        
            num_samples = get(obj.daq, 'SamplesAvailable');
            if num_samples > 0
                [force_traces, timestamp] = getdata(obj.daq, num_samples);
                for ii = 1:size(force_traces, 1)
                    force_traces(ii, :) = (force_traces(ii, :) - obj.zero_baseline).*obj.volts_2_newts;
                end
            else
                error('Bad reading from board!')
            end     
        end
    end % end methods
    
end % end classdef