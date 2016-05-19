function output = main

    try
        % Get important things into memory
		WaitSecs(0.001);
		GetSecs;
		Screen('preference', 'verbosity', 1);
        warning('off', 'all');
		addpath('src');
		
        % boilerplate initialization
        consts = Constants;
        ui = UserInputs;
        audio = PsychAudio(10);
        aud_dir = 'misc/sounds/';
        images = PsychImages(num_images, 'reversed', consts.reversed, 'scale', consts.scale);
        screen = PsychScreen('reversed', consts.reversed, 'big_screen', consts.big_screen, ...
                             'skip_tests', consts.skip_tests);
		output = AllocateData; % allocates for one block
        
        if ui.keyboard_or_force
			headers = {'id', 'day', 'block', 'trial', ...
					   'swapped', 'img_type', 'finger',...
					   'swap1', 'swap2', 'press1',...
					   't_press1', 'press2', 't_press2',...
					   'press3', 't_press3'};
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
		
		% use the date in the filename to prevent overwrites
		date_string = datestr(now, 30);
		date_string = date_string(3:end - 2);
		tfile_string = ui.tgt_name(1,:end - 4);
		filename = ['data/id', num2str(ui.subject_id), '_', tfile_string, ...
		            '_', date_string, '.mat'];
					
		% add headers
		fid = fopen(filename, 'wt');
        csvFun = @(str)sprintf('%s, ',str);
        xchar = cellfun(csvFun, headers, 'UniformOutput', false);
        xchar = strcat(xchar{:});
        xchar = strcat(xchar(1:end-1), '\n');
        fprintf(fid, xchar);
        fclose(fid);
		
        if strfind(ui.tgt_name, 'tr_')
            FillAudio(aud, [aud_dir, 'beepTrainFast.wav'], 1);
            FillAudio(aud, [aud_dir, 'smw_coin.wav'], 2);
            % use timed response experiment
        elseif strfind(ui.tgt_name, 'rt_')
            FillAudio(aud, [aud_dir, 'beep.wav'], 1);
            aud_names = dir([aud_dir, 'orch*.wav']);
            for ii = 1:length(aud_names)
                FillAudio(aud, [aud_dir, aud_names(ii)], ii);
            end
            
            % use serial reaction time experiment
        else
            error('unrecognized experiment');
        end
        
		
    catch
        PsychPurge;
    end

end