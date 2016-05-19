function block = AllocateData

	presses(1:5) = struct('index', int16(-1), 'rel_time_on', -1,...
					      'rel_time_off', -1, 'abs_time_on', -1, ...
					      'abs_time_off', -1);
	images(1) = struct('index', int16(-1), 'rel_time_on', -1, ...
					   'abs_time_on', -1);
	sounds(1) = struct('rel_time_on', -1, ...
					   'abs_time_on', -1);

	trial(1:150) = struct('presses', presses, ...
				          'images', images, ...
				          'sounds', sounds, ...
					      'forces', zeros(600, 11));

	block = struct('trial', trial, ...
				   'block_type', '', ...
				   'swapped', false,...
				   'image_type', '',...
				   'tfile_header', [], ...
				   'tfile', []);
end