function WriteTrTgt(day, block, swapped, image_type, repeats, easy_block)
    % day is the day (int)
    % block is the block (int)
    % swapped is a 1x2 vector of the swapped indices, or 0 if no swap 
    % image_type is 0 (hands) or 1 (symbols)
    % repeats is the number of repetitions for the entire array
    % easy_block overrides the image presentation times with some low number (1 = true)

    out_path = '~/Documents/BLAM/finger-5/misc/tfiles/'; % dirty
    seed = day * block;
    rand('seed', seed);
    ind_finger = [7 8 9 10];
    times = 0.3:0.05:0.8; % for 300ms period beep train

    % generate all combinations of times and images
    [a1, a2] = meshgrid(ind_finger, times);
    combos = repmat([a1(:) a2(:)], repeats, 1);
    combos = combos(randperm(size(combos, 1)), :);
    combo_size = size(combos, 1);

    if easy_block
        combos(:, 2) = 0.3; % show image at approx. the first beep
    end

    if any(swapped > 0) % if not zero
        combos(:, 3) = swapped(1);
        combos(:, 4) = swapped(2);
        swapped2 = 1;
    else
        combos(:, 3:4) = 0;
        swapped2 = 0;
    end

    % add catch trials
    num_catch = floor(combo_size/10);
    randind = randi([-2 2], 1, num_catch);
    catchind = (10:10:combo_size) + randind;
    if catchind(end) > combo_size
        catchind(end) = combo_size;
    end
    % finger, img_time, indices of two swapped images
    catch_trial = [-1 -1 combos(1, 3:4)];
    combos = insertrows(combos, catch_trial, catchind);
    combo_size = size(combos, 1);

    % day, block, trial, easy, swapped, image_type, tgt finger,
    % time, swap1, swap2
    final_output = [repmat(day, combo_size, 1) ...
                repmat(block, combo_size, 1) ...
                (1:combo_size)' ... % trials
                repmat(easy_block, combo_size, 1) ...
                repmat(swapped2, combo_size, 1) ...
                repmat(image_type, combo_size, 1) combos];
                
    file_name = ['tr_','dy',num2str(day), '_bk', num2str(block),...
                '_sw', num2str(swapped2), '_sh', num2str(image_type), '.tgt']; 
    dlmwrite([out_path, file_name], final_output, '\t', 'precision', 2);
end              