function output = main(tgt_path)

    try
        % Get important things into memory
		WaitSecs(0.001);
		GetSecs;
	    HideCursor;
		Screen('preference', 'verbosity', 1);
        warning('off', 'all');
		addpath(genpath('src'));
		
        % boilerplate initialization
        consts = Constants;
        ui = UserInputs;
        audio = PsychAudio(10);
        aud_dir = 'misc/sounds/';
        screen = PsychScreen('reversed', consts.reversed, 'big_screen', consts.big_screen, ...
                             'skip_tests', consts.skip_tests);
		output = AllocateData; % allocates for one block
		
        if nargin == 0
            tgt_path = ['misc/tfiles/', ui.tgt_name];
        end
		[tgt, header, rest] = ParseTgt(tgt_path, ',');
        output.id = ui.subject_id;
        output.tfile_header = header;
		output.tfile = rest;
        output.image_type = ifelse(tgt.image_type(1), 'shapes', 'hands');
        output.swapped = tgt.swapped(1);
		output.day = tgt.day(1);
		output.block_num = tgt.block(1);
        press_feedback = KeyFeedback(screen.dims(1), screen.dims(2),...
                              'num_boxes', length(unique(tgt.finger_index)));

        
		subdir = ifelse(tgt.image_type(1), 'shapes/', 'hands/');
        img_dir = ['misc/images/', subdir];
        img_names = dir([img_dir, '/*.jpg']);
        images = PsychImages(length(img_names),...
                             'reversed', consts.reversed,...
                             'scale', consts.scale);
        feedback_image = ImageFeedback(screen.window, screen.dims(1));

        
        for ii = 1:length(img_names)
            images = ImportImage(images, [img_dir, img_names(ii).name], ...
                                 ii, screen.window, screen.dims(1));
        end
		
        valid_indices = unique(tgt.finger_index);
        if ui.keyboard_or_force
            resp_device = KeyboardResponse(valid_indices,...
                                           'possible_keys', consts.possible_keys, ...
                                           'timing_tolerance', consts.timing_tolerance,...
                                           'force_min', consts.force_min,...
                                           'force_max', consts.force_max);
            Countdown(screen, resp_device);
        else
            resp_device = ForceResponse(valid_indices,...
                                        'sampling_freq', consts.sampling_freq,...
                                        'force_min', consts.force_min, ...
                                        'force_max', consts.force_max, ...
                                        'timing_tolerance', consts.timing_tolerance);
           resp_device.zero_baseline = Countdown(screen, resp_device);
        end
		
		% use the date in the filename to prevent overwrites
		date_string = datestr(now, 30);
		date_string = date_string(3:end - 2);
		tfile_string = tgt_path((max(strfind(tgt_path, '/'))+1):end - 4);
		filename = ['data/id', num2str(ui.subject_id), '_', tfile_string, ...
		            '_', date_string, '.mat'];
					
        if strfind(tgt_path, 'tr_')
            output.block_type = 'tr';
            FillAudio(audio, [aud_dir, 'beepTrainFast.wav'], 1);
            FillAudio(audio, [aud_dir, 'smw_coin.wav'], 2);
			
			for ii = 1:length(tgt.trial)
			    output = TimedRespTrial(screen, audio, images, resp_device,...
                                        press_feedback, tgt, output, ii);
			end
            
        elseif strfind(tgt_path, 'rt_')
            cccombo = 0; % keep track of current streak
			max_cccombo = 0; % keep track of max streak
			correct_counter = 0; % keep track of # correct (for P(correct) later)
			tttime = GetSecs;
            output.block_type = 'rt';
            FillAudio(audio, [aud_dir, 'beep.wav'], 1);
            aud_names = dir([aud_dir, 'orch*.wav']);
            for ii = 1:length(aud_names)
                FillAudio(audio, [aud_dir, aud_names(ii).name], ii+ 1);
            end
            
			for ii = 1:length(tgt.trial)
                [output, cccombo, correct_counter] = RapidTrial(screen, audio, images, resp_device, ...
                                               press_feedback, tgt, output, cccombo, ii, correct_counter, ...
                                               feedback_image);
			    max_cccombo = ifelse(cccombo > max_cccombo, cccombo, max_cccombo);
			end
			
			final_time = GetSecs - tttime;
			final_percent = correct_counter/length(tgt.trial);
            endstr = ['Final time: ', num2str(sprintf('%.2f',final_time)), ' seconds\n',...
                      'Percent correct: ', num2str(final_percent*100), '%\n',...
                      'Killing spree: ', num2str(max_cccombo)];
                  
            DrawFormattedText(screen.window, endstr, 'center', 'center', screen.text_colour);
            FlipScreen(screen);
            WaitSecs(5);
        else
            error('unrecognized experiment');
        end % end trial calls
        
		% save data to mat file (and convert to flat?)
        % remove unused trials
        output.trial(structfind(output.trial, 'abs_time_on', -1)) = [];
        if ~exist('data', 'dir')
           mkdir('data'); 
        end
		if IsOctave
		    save('-mat7-binary', filename, 'output');
		else
		    save(filename, 'output', '-v7');
		end
		PsychPurge;
		
    catch err
        PsychPurge;
        rethrow(err);
    end

end