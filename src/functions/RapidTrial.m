function [output, cccombo, correct_counter] = RapidTrial(screen, audio, images,...
                                        resp_device, press_feedback, tgt, output, cccombo, ii, correct_counter);

	% output.trial(ii)
	% refer to AllocateData for structure
	fail = false;
	temp_presses(1:3) = struct('index', int16(-1), 'rel_time_on', -1, 'abs_time_on', -1);
%	temp_releases(1:3) = struct('index', int16(-1), 'rel_time_off', -1, 'abs_time_off', -1);

	Priority(screen.priority);
	ref_time = GetSecs;
	output.trial(ii).abs_time_on = ref_time;
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
    [temp_out, temp_presses, updated_screen_press] = InnerRapidLoop(resp_device,...
	                                                                updated_screen_press, ...
	                                                                temp_presses, 1, ref_time);

	if temp_out(1) ~= tgt.finger_index(ii) % try 2
	    cccombo = 0;
		updated_screen_press = RapidPenalty(screen, resp_device, ...
		                                    tgt, images, press_feedback, ...
											updated_screen_press, ii);
		[temp_out, temp_presses, updated_screen_press] = InnerRapidLoop(resp_device,...
		                                                                updated_screen_press, ...
																		temp_presses, 2, ref_time);
		
		if temp_out(1) ~= tgt.finger_index(ii) % try 3
			updated_screen_press = RapidPenalty(screen, resp_device, ...
												tgt, images, press_feedback, ...
												updated_screen_press, ii);
			[temp_out, temp_presses, updated_screen_press] = InnerRapidLoop(resp_device,...
			                                                                updated_screen_press, ...
																			temp_presses, 3, ref_time);
			if temp_out(1) ~= tgt.finger_index(ii) % no more tries
			    fail = true;
				updated_screen_press = RapidPenalty(screen, resp_device, ...
									tgt, images, press_feedback, ...
									updated_screen_press, ii);
			end		
		end
		
	else % correct on the first try
		
		correct_counter = correct_counter + 1;
		if temp_out(2) - time_image < 0.5 % only increment if fast
		    PlayAudio(audio, ifelse(cccombo + 2 > 9, 9, cccombo + 2));
			cccombo = cccombo + 1;
		end
    end
	
	Priority(0);
	if isa(resp_device, 'ForceResponse')
	    [force_traces, timestamp] = CheckFullResponse(resp_device);
		force_traces = sum(force_traces, 1)/size(force_traces, 1);
		output.trial(ii).forces = [timestamp; force_traces]; % check dims!
    else
		output.trial(ii).forces = []; % 
	end
	
	StopKeyResponse(resp_device);
	output.trial(ii).images.abs_time_on = time_image;
	output.trial(ii).images.index = tgt.image_index(ii);
	output.trial(ii).images.rel_time_on = time_image - ref_time;
	output.trial(ii).sounds.abs_time_on = time_audio;
	output.trial(ii).sounds.rel_time_on = time_audio - ref_time;
	temp_presses(structfind(temp_presses, 'rel_time_on', -1)) = []; % prune unused fields (should have at least one)
	output.trial(ii).press_ons = temp_presses;
	output.trial(ii).press_offs = []; % kill until I come up with a better sampling schema
	
	
	temp_col = ifelse(fail, 'blue', 'green');
	WipeScreen(screen);
	DrawOutline(press_feedback, screen.window);
	DrawFill(press_feedback, screen.window, temp_col, updated_screen_press, 0);
	DrawImage(images, tgt.image_index(ii), screen.window);
	FlipScreen(screen);
	WaitSecs(.2); % show feedback briefly
										
end