function output = TimedRespTrial(screen, audio, images, resp_device, ...
                                 feedback, tgt, output, ii);

	% output.block.trial(ii)
	% refer to AllocateData for structur
	Priority(screen.priority);
	output.block.trial(ii).abs_time_on = GetSecs;
	% The audio onset will be used as the "true" trial start
    WipeScreen(screen);
	DrawOutline(feedback, screen.window);
	time_flip = FlipScreen(screen);
	
	% DrawImage(images, tgt.image_index(ii), screen.window);
	
	Priority(0);
	
end