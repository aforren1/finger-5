classdef UserInputs
    properties
        subject_id;
        day;
        block;
        big_screen;
        keyboard_or_force;
        tgt_name;
    end
    
    methods
        function out = UserInputs
            out.subject_id = input('What is the subject ID (numeric)? ');
            out.day = input('Which day is it (numeric, ie. 1 through 5)? ');
            out.block = input('Which block is it (numeric, ie. 1 through 10)? ');
            out.big_screen = false;
            out.keyboard_or_force = true;
            out.tgt_name = GuessTgt(out);
        end
        
        function out = GuessTgt(ui)
            try
                tfiles = dir(fullfile('misc/tfiles/', '*.tgt'));
                tfiles = {tfiles.name}';
                index = find(cellfun('length', ...
                            regexp(tfiles, ['dy', num2str(ui.day), '_bk', num2str(ui.block), '_'])) == 1);
                out = tfiles{index};
            catch
                warning('No matching target file!')
                out = -1;
            end
        
        end
    end 
end
        