% on the wishlist, to cut down the crud in the trial loop.


function [temp_out, temp_presses, u_s_p] = InnerRapidLoop(resp_dev, u_s_p, temp_presses, ii, ref_time)
    temp_out = [-1 -1];
    while temp_out(1) == -1
        [temp_out, u_s_p] = CheckKeyResponse(resp_dev, u_s_p);
        WaitSecs(0.01);
    end		

    temp_presses(ii).index = temp_out(1);
    temp_presses(ii).abs_time_on = temp_out(2);
    temp_presses(ii).rel_time_on = temp_out(2) - ref_time;

end