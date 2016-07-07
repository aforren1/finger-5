% timings for string -> matrix conversion
% 1. combined strsplit (gives us a cell array) + str2double (supposed to be fast)
% 2. just str2double (strsplit really slow?)
% 3. str2num (uses eval, more catch-all)
% 4. sscanf (need to also take transpose)
str1 = '23566 111';
str2 = strsplit(str1, ' ');
nn = 1e5;

tic;
for ii = 1:nn
    str2double(strsplit(str1, ' '));
end
toc

tic;
for ii = 1:nn
    str2double(str2);
end
toc

tic;
for ii = 1:nn
    str2num(str1);
end
toc

tic
for ii = 1:nn
    sscanf(str1, '%d')';
end
toc

% MATLAB times:
%Elapsed time is 18.703379 seconds.
%Elapsed time is 3.738220 seconds.
%Elapsed time is 1.840554 seconds.
%Elapsed time is 0.496901 seconds.

% Octave times:
%Elapsed time is 27.2873 seconds.
%Elapsed time is 0.759014 seconds.
%Elapsed time is 10.3317 seconds.
%Elapsed time is 1.39586 seconds.

% sscanf is the overall winner!
