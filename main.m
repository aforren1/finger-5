function output = main

    % boilerplate initialization
    ui = UserInputs;

    if strfind(ui.tgt_name, 'tr_')

    elseif strfind(ui.tgt_name, 'rt_')

    else
        error('unrecognized experiment');
    end


end