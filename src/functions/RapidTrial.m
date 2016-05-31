function [output, cccombo, correct_counter] = RapidTrial(screen, audio, images,...
                                        resp_device, press_feedback, tgt, output,...
                                        cccombo, ii, correct_counter, feedback_image)

    wrong = false; % wrong guess 
    fail = false; % missed three times
    tries = 1; % number of attempts
    tries_rel = 1;
    tries_ignored = 1;
    tries_ignored_rel = 1;
    
	temp_presses(1:3) = struct('index', int16(-1), 'rel_time_on', -1, 'abs_time_on', -1);
    temp_ignore_press(1:10) = struct('index', int16(-1), 'rel_time_on', -1, 'abs_time_on', -1);
    temp_releases(1:3) = struct('index', int16(-1), 'rel_time_off', -1, 'abs_time_off', -1);
    temp_ignore_release(1:10) = struct('index', int16(-1), 'rel_time_off', -1, 'abs_time_off', -1);


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
    time_audio = time_flip + screen.ifi; % time_audio is reference for the trial
    PlayAudio(audio, 1, time_audio);
	time_image = time_flip + 0.5 * screen.ifi;
	time2 = FlipScreen(screen, time_image); % use this time for loop spacing
	StartKeyResponse(resp_device);

	updated_screen_press = zeros(1, length(resp_device.valid_indices));

    % loop until certain conditions are met
    % break on too many guesses
    while tries < 4
        
        WipeScreen(screen);
        DrawOutline(press_feedback, screen.window);
        DrawImage(images, tgt.image_index(ii), screen.window);
        
        if wrong
            if GetSecs > time_wrong % reset wrong counter
                wrong = false;
            else
                DrawFill(press_feedback, screen.window, 'red', ...
                         bad_screen_press, 0);
                DrawImageFeedback(feedback_image, screen.window);
            end
        end
        
        % save all presses
        temp_out = [-1 -1];
        temp_rel = temp_out;
        [temp_out, updated_screen_press, temp_rel] = CheckKeyResponse(resp_device, updated_screen_press);
        if temp_out(1) > 0      
            if ~wrong
                temp_presses(tries).index = temp_out(1);
                temp_presses(tries).abs_time_on = temp_out(2);
                temp_presses(tries).rel_time_on = temp_out(2) - ref_time;
                tries = tries + 1;
            else
                temp_presses(tries).index = temp_out(1);
                temp_presses(tries).abs_time_on = temp_out(2);
                temp_presses(tries).rel_time_on = temp_out(2) - ref_time;
                tries_ignored = tries_ignored + 1;
            end
        end
        
        if temp_rel(1) > 0
            if ~wrong
                temp_releases(tries_rel).index = temp_rel(1);
                temp_releases(tries_rel).abs_time_off = temp_rel(2);
                temp_releases(tries_rel).rel_time_off = temp_rel(2) - ref_time;
                tries_rel = tries_rel + 1;
            else
                temp_ignore_release(tries_ignored_rel).index = temp_rel(1);
                temp_ignore_release(tries_ignored_rel).abs_time_off = temp_rel(2);
                temp_ignore_release(tries_ignored_rel).rel_time_off = temp_rel(2) - ref_time;
                tries_ignored_rel = tries_ignored_rel + 1;         
            end
        end % end of press saving
        
        if ~wrong
            if temp_out(1) > 0
                if temp_out(1) ~= tgt.finger_index(ii)
                    wrong = true;
                    cccombo = 0;
                    time_wrong = GetSecs + 1;
                    DrawFill(press_feedback, screen.window, 'red', ...
                             updated_screen_press, 0);
                    bad_screen_press = updated_screen_press;
                else % correct answer
                    break;
                end
            end           
        end
        
        time2 = FlipScreen(screen, time2 + 0.5 * screen.ifi);
              
    end % while true loop
    
    Priority(0);
    if tries == 2 % successful on first go
        correct_counter = correct_counter + 1;
        if temp_out(2) - time_image < 0.5
        	PlayAudio(audio, ifelse(cccombo + 2 > 9, 9, cccombo + 2), 0);
            cccombo = cccombo + 1;
        end
        
    elseif wrong
        WipeScreen(screen);
        DrawOutline(press_feedback, screen.window);
        DrawImage(images, tgt.image_index(ii), screen.window);
        % fill in the correct index
        updated_screen_press = zeros(1, length(resp_device.valid_indices));
        updated_screen_press(resp_device.valid_indices == tgt.finger_index(ii)) = 1;
        fail = true;
    end
    
    % draw correct feedback
    tempcol = ifelse(fail, 'blue', 'green');
    DrawFill(press_feedback, screen.window, tempcol, updated_screen_press, 0);
    
    FlipScreen(screen);
    WaitSecs(.2);
    
	if isa(resp_device, 'ForceResponse')
	    [force_traces, timestamp] = CheckFullResponse(resp_device);
		% subtract the mean to center on zero
		for nn = 1:size(force_traces, 1)		
		    force_traces(nn) = force_traces(nn) - (sum(force_traces, 1)/size(force_traces, 1)); 
	    end
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
	temp_releases(structfind(temp_releases, 'rel_time_off', -1)) = [];
    output.trial(ii).press_offs = temp_releases;
    
    temp_ignore_press(structfind(temp_ignore_press, 'rel_time_on', -1)) = [];
    output.trial(ii).ignore_ons = temp_ignore_press;
    temp_ignore_release(structfind(temp_ignore_release, 'rel_time_off', -1)) = [];
    output.trial(ii).ignore_offs = temp_ignore_release;   

end