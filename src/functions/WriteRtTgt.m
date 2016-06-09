function WriteRtTgt(out_path, varargin)
    % note: to keep down the moving parts, the swap *must* be defined when
    % the tgt file is generated, ie. ('swapped', [3 1], 'ind_img', 7:10). The
    % swap will be computed here
    % copy-paste test:
    % WriteRtTgt('~/Documents/BLAM/finger-5/misc/tfiles/');
    % More thorough example:
    % WriteRtTgt('~/Documents/BLAM/finger-5/misc/tfiles/', ...
    %            'day', 2, 'block', 4, 'swapped', [1 3],...
    %            'image_type', 1, 'repeats', 1, ...
    %            'ind_finger', 7:10, 'ind_img', 1:4)

    opts = struct('day', 1, 'block', 1, 'swapped', 0, ...
                'image_type', 0, 'repeats', 1, ...
                'ind_finger', 7:10, 'ind_img', 7:10);
    opts = CheckInputs(opts, varargin{:});

    day = opts.day;
    block = opts.block;
    swapped = opts.swapped;
    image_type = opts.image_type;
    repeats = opts.repeats;
    ind_finger = opts.ind_finger;
    ind_img = opts.ind_img;

    if length(ind_finger) ~= length(ind_img)
        error('Cannot handle weird mappings, make sure ind_finger and ind_img are the same length.');
    end

    if any(swapped > length(ind_finger))
        error('Swapping goes by index, not the actual value.');
    end

    if any(diff(ind_img) < 0) || any(diff(ind_img) < 0)
        error('Make sure to define indices in increasing order.')
    end

    seed = day * block; % avoid explicit patterns in seeding
    rand('seed', seed);
    ind_finger = repmat([ind_finger; ind_img]', repeats, 1);
    limit = 10000;
    maxnum = 3;
    count = 1;
    while count < limit
        combos = ind_finger(randperm(size(ind_finger, 1)), :);
        i = [find(combos(1:end - 1, 1) ~= combos(2:end, 1)); length(combos)];
        l = diff([0; i]);

        if any(l > maxnum) % no more than two allowed
            count = count + 1;
        else
            break;
        end
    end

    combo_size = size(combos, 1);

    if any(swapped > 0) % if not zero
        combos(:, 3) = swapped(1);
        combos(:, 4) = swapped(2);
        swapped2 = 1;
        ind_img([swapped(2), swapped(1)]) = ind_img([swapped(1), swapped(2)]);
    else
        combos(:, 3:4) = 0;
        swapped2 = 0;
    end

    % day, block, trial, easy, swapped, image_type, tgt finger,
    % time, swap1, swap2
    final_output = [repmat(day, combo_size, 1) ...
                    repmat(block, combo_size, 1) ...
                    (1:combo_size)' ... % trials
                    repmat(swapped2, combo_size, 1) ...
                    repmat(image_type, combo_size, 1) combos];

    file_name = ['rt_','dy',num2str(day), '_bk', num2str(block), ...
                 '_sw', num2str(swapped2), '_sh', num2str(image_type), '.tgt'];
    headers = {'day', 'block', 'trial', 'swapped', 'image_type', ...
               'finger_index', 'image_index', 'swap_index_1', 'swap_index_2'};

	fid = fopen([out_path, file_name], 'wt');
	csvFun = @(str)sprintf('%s, ', str);
	xchar = cellfun(csvFun, headers, 'UniformOutput', false);
	xchar = strcat(xchar{:});
	xchar = strcat(xchar(1:end-1), '\n');
	fprintf(fid, xchar);
	fclose(fid);

    dlmwrite([out_path, file_name], final_output, '-append', 'precision', 4);
end
