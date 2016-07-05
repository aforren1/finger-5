classdef TimedResponse < Experiment
    properties
        screen;
        audio;
        images;
        x_image;
    end

    methods
	    function consts = Constants
            consts = struct('timing_tolerance', 0.075, ...
                            'possible_keys', {{'a','w','e','f','v','b','h','u','i','l'}}, ...
                            'force_min', 1, ...
                            'force_max', 5, ...
                            'sampling_freq', 200, ...
                            'skip_tests', true, ...
                            'scale', 0.22);
		end

        function o = TimedResponse(tgt)
            o@Experiment;
            o.valid_states = {'idle',...
                              'intrial',...
                              'posttrial',...
                              'endblock'};
            o.current_state = 'idle';
            consts = o.Constants;
            o.screen = BlamScreen('reversed', consts.reversed,...
                                  'big_screen', consts.big_screen, ...
                                  'skip_tests', consts.skip_tests);

            % audio
            o.audio = BlamAudio;
            o.audio.FillAudio(['misc/sounds/', 'beepTrainFast.wav'], 1, 'stereo');
            o.audio.FillAudio(['misc/sounds/', 'smw_coin.wav'], 2, 'stereo');

            %images
            subdir = ifelse(tgt.image_type(1), 'shapes/', 'hands/');
            img_dir = ['misc/images/', subdir];
            img_names = dir([img_dir, '/*.jpg']);
            o.images = BlamImages(length(img_names),...
                                   'reversed', consts.reversed,...
                                   'scale', consts.scale);
            for ii = 1:length(img_names)
                o.images = o.images.ImportImage([img_dir, img_names(ii).name], ...
                                       ii, o.screen.window, o.screen.dims(1));
            end

            o.x_image = ImageFeedback(o.screen.window, o.screen.dims(1));

            % response device
            valid_indices = unique(tgt.finger_index);
            if ui.keyboard_or_force
                resp_device = KeyboardResponse(valid_indices,...
                                               'possible_keys', consts.possible_keys, ...
                                               'timing_tolerance', consts.timing_tolerance,...
                                               'force_min', consts.force_min,...
                                               'force_max', consts.force_max);
                Countdown(screen);
            else
                resp_device = ForceResponse(valid_indices,...
                                            'sampling_freq', consts.sampling_freq,...
                                            'force_min', consts.force_min, ...
                                            'force_max', consts.force_max, ...
                                            'timing_tolerance', consts.timing_tolerance);
                Countdown(screen); %resp_device.zero_baseline =
            end

            % output data structure

            % counters
        end

        % delegate
        function [long_data, summary_data] = StateMachine(o, tgt, long_data, summary_data)
            switch State(o.current_state)
                case 'idle' % between/before trials

                case 'intrial' % during trial

                case 'posttrial' % after trial cleanup

                if trialnum >= max(tgt.trial)
                    o.current_state = 'endblock';

                end
                case 'endblock' % after block cleanup
                otherwise
                    error('Unknown state');
            end
        end

		% allocate arrays for summary data and complete data for the entire block
        % id is subject id
	    function [summary_data, full_data] = AllocateData(o, tgt, id)
	        % do we want a struct (for the names) or a matrix (and keep track of columns)?
            % names: id, day,block,trial,easy,swapped,image_type,
            % image_time,finger_index,image_index,swap_index_1,swap_index_2
            % press1, press1_time, press2, press2_time
            summary_data = zeros(length(tgt.day), 16) - 1;

            % updated each loop.
            % names: id, day, block, trial, easy, swapped, image_type, image_time,
            % finger_index, image_index, swap_index_1, swap_index_2,
            % current_state, press_event, press_index, press_time, key_states,image_on

            % key_states is the 1xn array representing the current state of the keys
            % (0 or 1 for keyboard, some force level for transducers)
            % need to do post-block pruning of this one
            full_data = zeros(100000, 18) - 1;

	    end
    end % end methods
end % end timed response
