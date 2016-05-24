function [output, cccombo] = RapidTrial(screen, audio, images,...
                                        resp_device, press_feedback, tgt, output, cccombo, ii);

	% output.block.trial(ii)
	% refer to AllocateData for structure
	fail = false;
	temp_presses(1:3) = struct('index', int16(-1), 'rel_time_on', -1,...
					           'rel_time_off', -1, 'abs_time_on', -1, ...
					           'abs_time_off', -1);
	Priority(screen.priority);
	ref_time = GetSecs;
	output.block.trial(ii).abs_time_on = ref_time;
	% The audio onset will be used as the "true" trial start
    WipeScreen(screen);
	DrawOutline(press_feedback, screen.window);
	time_flip = FlipScreen(screen);
	
	% get things ready for trial
	WipeScreen(screen);
	DrawOutline(press_feedback, screen.window);
	DrawImage(images, tgt.image_index(ii), screen.window);
	
	% play audio and show sound at the "same time"
    time_audio = time_flip + screen.ifi;
    PlayAudio(audio, 1, time_audio);
	time_image = time_flip + 0.5 * screen.ifi;
	FlipScreen(screen, time_image);
	StartKeyResponse(resp_device);
	
	
	updated_screen_press = zeros(1, length(resp_device.valid_indices));
    [temp_out, temp_presses, updated_screen_press] = InnerRapidLoop(resp_device, updated_screen_press, ...
	                                                                temp_presses, 1);
	
	if temp_out(1) ~= tgt.finger_index(ii) % try 2
	    cccombo = 0;
		updated_screen_press = RapidPenalty(screen, resp_device, ...
		                                    tgt, images, press_feedback, ...
											updated_screen_press, ii);
		[temp_out, temp_presses, updated_screen_press] = InnerRapidLoop(resp_device, updated_screen_press, ...
																		temp_presses, 2);
		
		if temp_out(1) ~= tgt.finger_index(ii) % try 3
			updated_screen_press = RapidPenalty(screen, resp_device, ...
												tgt, images, press_feedback, ...
												updated_screen_press, ii);
			[temp_out, temp_presses, updated_screen_press] = InnerRapidLoop(resp_device, updated_screen_press, ...
																			temp_presses, 3);
			if temp_out(1) ~= tgt.finger_index(ii) % no more tries
			    fail = true;
			end		
		end
		
	else % correct on the first try
		if temp_out(2) - time_image < 0.5 % only increment if fast
		    PlayAudio(audio, ifelse(cccombo + 2 > 9, 9, cccombo + 2));
			cccombo = cccombo + 1;
		end
    end
	
	Priority(0);
	if class(resp_device) == 'ForceResponse'
	    [force_traces, timestamp] = CheckFullResponse(resp_device);
		output.block.trial(ii).forces = [timestamp; force_traces]; % check dims!
	end
	
	StopKeyResponse(resp_device);
	output.block.trial(ii).images.abs_time_on = time_image;
	output.block.trial(ii).images.index = tgt.image_index(ii);
	output.block.trial(ii).images.rel_time_on = time_image - ref_time;
	output.block.trial(ii).sounds.abs_time_on = time_audio;
	output.block.trial(ii).sounds.rel_time_on = time_audio - ref_time;
	output.block.trial(ii).presses = temp_presses;
	
	
										
end