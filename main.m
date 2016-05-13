function output = main

    % boilerplate initialization
    ui = UserInputs;
    
    
    if ui.keyboard_or_force
        resp_device = KeyboardResponse(valid_indices);
    else
        resp_device = ForceResponse(valid_indices);
    end

    if strfind(ui.tgt_name, 'tr_')
        % use timed response experiment
    elseif strfind(ui.tgt_name, 'rt_')
        % use serial reaction time experiment
    else
        error('unrecognized experiment');
    end


end