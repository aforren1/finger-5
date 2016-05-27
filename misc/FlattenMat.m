% thinking out how to reshape the nested struct into a 
% one-row-per-observation struct/cell
for ii = 1:length(output.trial) % loop over trials
    
    if ~isempty(output.trial(ii).press_ons)
        for jj = 1:length(output.trial(ii).press_ons) % loop over press ons
        
        end  
    end
    
    if ~isempty(output.trial(ii).press_offs)
        for kk = 1:length(output.trial(ii.press_offs))
        
        end
    end
end