function output = main

    % boilerplate initialization
	consts = Constants;
    ui = UserInputs;
    audio = PsychAudio(10);
	images = PsychImages(num_images, 'reversed', consts.reversed, 'scale', consts.scale);
	screen = PsychScreen('reversed', consts.reversed, 'big_screen', consts.big_screen, ...
	                     'skip_tests', consts.skip_tests);
	
	
    
    if ui.keyboard_or_force
        resp_device = KeyboardResponse(valid_indices,...
                                  	   'possible_keys', consts.possible_keys, ...
		                               'timing_tolerance', consts.timing_tolerance,...
									   'force_min', consts.force_min,...
                                       'force_max', consts.force_max);
    else
        resp_device = ForceResponse(valid_indices,...
                            		'sampling_freq', consts.sampling_freq,...
                                    'force_min', consts.force_min, ...
                                    'force_max', consts.force_max, ...
                                    'timing_tolerance', consts.timing_tolerance);
    end

    if strfind(ui.tgt_name, 'tr_')
        % use timed response experiment
    elseif strfind(ui.tgt_name, 'rt_')
        % use serial reaction time experiment
    else
        error('unrecognized experiment');
    end


end