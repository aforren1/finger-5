function output = main

    try
        
        % boilerplate initialization
        consts = Constants;
        ui = UserInputs;
        audio = PsychAudio(10);
        aud_dir = 'misc/sounds/';
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