function out = ParseTgt(filename)
% Thinking something like:
% header = test;
% header = test2;
% header = test3;
% _
% header1, header2, header3
% val1, val2, val3 \n 
% val4, val5, val6 \n
% 
% This will go on the backburner, because my current solution
% involves `eval`ing the top
%
% Should data then be saved in a "long" format, or would something
% like HDF5 or csvy (csv + YAML header) be more flexible? Then it's 
% a matter of parsing the top vs bottom

end