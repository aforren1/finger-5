function [output, cccombo] = RapidTrial(screen, audio, images,...
                                        resp_device, feedback, tgt, output, cccombo, ii);

	% output.block.trial(ii)
	% refer to AllocateData for structure
	
	temp_presses(1:3) = struct('index', int16(-1), 'rel_time_on', -1,...
					           'rel_time_off', -1, 'abs_time_on', -1, ...
					           'abs_time_off', -1);
	Priority(screen.priority);
	ref_time = GetSecs;
	output.block.trial(ii).abs_time_on = ref_time;
	% The audio onset will be used as the "true" trial start
    WipeScreen(screen);
	DrawOutline(feedback, screen.window);
	time_flip = FlipScreen(screen);
	
	% get things ready for trial
	WipeScreen(screen);
	DrawOutline(feedback, screen.window);
	DrawImage(images, tgt.image_index(ii), screen.window);
	
	% play audio and show sound at the "same time"
    time_audio = time_flip + screen.ifi;
    PlayAudio(audio, 1, time_audio);
	time_image = time_flip + 0.5 * screen.ifi;
	FlipScreen(screen, time_image);
	StartKeyResponse(resp_device);
	
	
	updated_screen_press = zeros(1, length(resp_device.valid_indices));
	temp_out = [-1 -1];
	while temp_out(1) == -1
	    [temp_out, updated_screen_press] = CheckKeyResponse(resp_device, updated_screen_press);
		WaitSecs(0.01);
	end
	temp_presses(1).index = temp_out(1);
	temp_presses(1).abs_time_on = temp_out(2);
	temp_press(1).rel_time_on = temp_out(2) - ref_time;
	
	if temp_out(1) ~= tgt.finger_index(ii)
	
	
	
	output.block.trial(ii).images.abs_time_on = time_image;
	output.block.trial(ii).images.index = tgt.image_index(ii);
	output.block.trial(ii).images.rel_time_on = time_image - ref_time;
	output.block.trial(ii).sounds.abs_time_on = time_audio;
	output.block.trial(ii).sounds.rel_time_on = time_audio - ref_time;
	output.block.trial(ii).presses = temp_presses;
	
	
	Priority(0);
										
end