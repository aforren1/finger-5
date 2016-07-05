classdef UserInputs
    properties
        subject_id;
        day;
        block;
        big_screen;
        keyboard_or_force;
        tgt_name;
        use_serial;
        exp_type;
    end

    methods
        function out = UserInputs
            out.subject_id = input('What is the subject ID (numeric)? ');
            out.day = input('Which day is it (numeric, ie. 1 through 5)? ');
            out.block = input('Which block is it (numeric, ie. 1 through 10)? ');
            % check for valid experiment types?
            out.exp_type = input('Expected experiment type? tr... (no quotes): ', 's');
            out.use_serial = false; %input('Use serial port? true or false. ');
            out.big_screen = false;
            out.keyboard_or_force = true;
            out.tgt_name = GuessTgt(out);
        end

        function out = GuessTgt(ui)
            try
                tfiles = dir(fullfile('misc/tfiles/', '*.tgt'));
                tfiles = {tfiles.name}';
                index = find(cellfun('length', ...
                            regexp(tfiles, [ui.exp_type, '_dy', num2str(ui.day), '_bk', num2str(ui.block)])));
                if isempty(index)
                    warning('No matching target file!');
                    out = -1;
                else
                    out = ['misc/tfiles/', tfiles{index}];
                end
            catch
                warning('No matching target file!')
                out = -1;
            end

        end

        function out = Tgt(ui)
            out = ui.tgt_name;
        end

        function out = Type(ui)
            out = ui.exp_type;
        end
    end
end
