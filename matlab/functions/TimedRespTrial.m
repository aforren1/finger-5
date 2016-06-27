function output = TimedRespTrial(screen, audio, images, resp_device, ...
                                 press_feedback, tgt, output, ii);

	% output.trial(ii)
	% refer to AllocateData for structure
	save_image_time = false;

	temp_presses(1:3) = struct('index', int16(-1), 'rel_time_on', -1, 'abs_time_on', -1);
	temp_releases(1:3) = struct('index', int16(-1), 'rel_time_off', -1, 'abs_time_off', -1);

	press_count = 1;
	release_count = 1;

	updated_screen_press = zeros(1, length(resp_device.valid_indices));
	num_frames = round(1.7/screen.ifi);
	first_screen_press = updated_screen_press;
	Priority(screen.priority);
	output.trial(ii).abs_time_on = GetSecs;
	% The audio onset will be used as the "true" trial start
    WipeScreen(screen);
	DrawOutline(press_feedback, screen.window);
	time_flip = FlipScreen(screen);

	WipeScreen(screen);
	DrawOutline(press_feedback, screen.window);

	time_audio = time_flip + screen.ifi;
	time_flip2 = time_flip + 0.5 * screen.ifi;
	if tgt.image_time < 0
	    img_frame = -1;
		time_image = -1;
	else % not a catch trial
	    % built-in 500 ms of silence on the click train
		img_frame = round((0.5 + tgt.image_time(ii))/screen.ifi);
    end

    PlayAudio(audio, 1, time_audio);
	ref_time = time_audio;
	time_flip3 = FlipScreen(screen, time_flip2);
	StartKeyResponse(resp_device);

	for frame = 1:num_frames
	    WipeScreen(screen);
		DrawOutline(press_feedback, screen.window);

		if frame >= img_frame
            Screen('FillOval', screen.window, [255 255 255], [ 0 0 100 100]);
		    DrawImage(images, tgt.image_index(ii), screen.window);
			if frame == img_frame
			    save_image_time = true;
			else
			    save_image_time = false;
			end
	    end

		% check keyboard
		temp_press = [-1 -1];
		temp_release = [-1 -1];
		[temp_press, updated_screen_press, temp_release] = CheckKeyResponse(resp_device, updated_screen_press);
		if temp_press(1) > 0 && press_count < 4
		    temp_presses(press_count).index = temp_press(1);
			temp_presses(press_count).abs_time_on = temp_press(2);
			temp_presses(press_count).rel_time_on = temp_press(2) - time_audio;

		    if press_count == 1
			    first_screen_press = updated_screen_press;
		    end
			press_count = press_count + 1;
		end

		if temp_release(1) > 0 && release_count < 4
		    temp_releases(release_count).index = temp_release(1);
			temp_releases(release_count).abs_time_off = temp_release(2);
			temp_releases(release_count).rel_time_off = temp_release(2) - time_audio;

			release_count = release_count + 1;
	    end
		% draw temporary feedback
		DrawFill(press_feedback, screen.window, 'gray', updated_screen_press, 0);

		time_flip3 = FlipScreen(screen, time_flip3 + 0.5*screen.ifi);
		if save_image_time
		    time_image = time_flip3;
		end

	end


	Priority(0);
    StopKeyResponse(resp_device);

	if isa(resp_device, 'ForceResponse')
	    [force_traces, timestamp] = CheckFullResponse(resp_device);
% 		% subtract the mean to center on zero
% 		for nn = 1:size(force_traces, 1)
%             for pp = 1:size(force_traces, 2)
%  		        force_traces(nn, pp) = force_traces(nn, pp) - median(force_traces(:,pp));
%             end
%         end
		output.trial(ii).forces = [timestamp, force_traces]; % check dims!
    else
		output.trial(ii).forces = []; % saves space
	end

	WipeScreen(screen);
	DrawOutline(press_feedback, screen.window);

	% show feedback wrt correctness
	if time_image > 0 % there was an image, so correctness matters
	    if temp_presses(1).index == tgt.finger_index(ii)
		    temp_colour = 'green';
			feedback_parts = 1;
		else
		    temp_colour = 'red';
			feedback_parts = 0;
		end
	    DrawImage(images, tgt.image_index(ii), screen.window);
		output.trial(ii).images.abs_time_on = time_image;
    	output.trial(ii).images.rel_time_on = time_image - ref_time;

	else % any press correct
	    temp_colour = 'green';
	    output.trial(ii).images.abs_time_on = -1;
		output.trial(ii).images_rel_time_on = -1;
		feedback_parts = 1;
	end
	DrawFill(press_feedback, screen.window, temp_colour, first_screen_press, 0);

	time_diff = temp_presses(1).rel_time_on - 1.4; % magic number
	if time_diff == -2.4 || time_diff > resp_device.timing_tolerance
	    tempstr = 'Too late!';
		feedback_parts = 0;
		DrawFill(press_feedback, screen.window, 'black', first_screen_press, 0.2); % hack
    elseif time_diff < -resp_device.timing_tolerance
	    tempstr = 'Too early!';
		feedback_parts = 0;
		DrawFill(press_feedback, screen.window, 'black', first_screen_press, 0.2);
    else
        tempstr = 'Good timing!';
        feedback_parts = feedback_parts + 1;
    end

    DrawFormattedText(screen.window, tempstr, 'center', ...
	                  screen.dims(2)*0.18, screen.text_colour);

    FlipScreen(screen);

    if feedback_parts > 1
        PlayAudio(audio, 2, 0);
	end
	output.trial(ii).images.index = tgt.image_index(ii);
	output.trial(ii).sounds.abs_time_on = time_audio;
	output.trial(ii).sounds.rel_time_on = time_audio - ref_time;
	temp_presses(structfind(temp_presses, 'rel_time_on', -1)) = []; % prune unused fields (should have at least one)
	temp_releases(structfind(temp_releases, 'rel_time_off', -1)) = [];
	output.trial(ii).press_ons = temp_presses;
	output.trial(ii).press_offs = temp_releases;

	output.trial(ii).ignore_ons = [];
	output.trial(ii).ignore_offs = [];

	WaitSecs(0.2);


end
