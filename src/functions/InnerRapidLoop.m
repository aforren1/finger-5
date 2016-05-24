% on the wishlist, to cut down the crud in the trial loop.
% however, it ends up passing 
%function out = InnerRapidLoop(in)
%
%end

function [temp_out, temp_presses] = InnerRapidLoop(resp_dev,...
                                                   u_s_p, temp_presses, ii)
    temp_out = [-1 -1];
    while temp_out(1) == -1
        [temp_out, u_s_p] = CheckKeyResponse(resp_device, u_s_p);
        WaitSecs(0.01);
    end		

    temp_presses(ii).index = temp_out(1);
    temp_presses(ii).abs_time_on = temp_out(2);
    temp_press(ii).rel_time_on = temp_out(2) - ref_time;

end