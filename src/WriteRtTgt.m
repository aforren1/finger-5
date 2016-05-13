function WriteRtTgt(day, block, swapped, image_type, repeats)

    % day is the day (integer)
    % block is the block number (int)
    % easy is whether the time is easy (500 ms fixed img presentation) or not
    % swapped is 1x2 vector of the swapped image indices (or 0 if no swap)
    % image_type is 0 (hands) or 1 (shapes)
    % repeats is the number of repetitions for entire array
    % out_path is the output path
    % filename is determined by args, eg. 'dy1_bk1_ez1_sw0_sh1.tgt' would be
    % 'day 1, block 1, easy, no swaps, shapes'.
    out_path = '~/Documents/BLAM/finger-5/misc/tfiles/'; % change for your comp!
    seed = day * block; % avoid explicit patterns in seeding
    %rng(seed);
    rand('seed', seed);
    ind_finger = [7 8 9 10];
    ind_finger = repmat(ind_finger, 1, repeats);
    combos = ind_finger(:, randperm(size(ind_finger, 2)))'; % lazy
    combo_size = size(combos, 1);

    if any(swapped > 0) % if not zero
        combos(:, 2) = swapped(1);
        combos(:, 3) = swapped(2);
        swapped2 = 1;
    else
        combos(:, 2:3) = 0;
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

    dlmwrite([out_path, file_name], final_output, '\t');
end



