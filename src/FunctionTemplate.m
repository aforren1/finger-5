function output = FunctionTemplate(varargin)
% http://stackoverflow.com/questions/2775263/how-to-deal-with-name-value-pairs-of-function-arguments-in-matlab
% for light reading about multiple (optional and required) args

% check for too few inputs
%# define defaults at the beginning of the code so that you do not need to
%# scroll way down in case you want to change something or if the help is
%# incomplete
opts = struct('firstparameter', 1, 'secondparameter', magic(3));
opts = CheckInputs(opts, varargin{:}); % this pattern ought to be pretty constant


end