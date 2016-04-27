function res = ifelse(cond, res_true, res_false)
% This function is a shortcut for simple if conditions.
% There are two possible uses:
%	1) Assigning a value to variable, depending on the condition result.
%	   Example:   A = ifelse(B, C, D);
%	   will execute A=C if B is true and A=D if B is false
%	   if B is a matrix, C&D must be scalars or the same size of B
%
%	2) Running an expression using "eval".
%	   Example:   ifelse(B, 'A=C;', 'D=E;');
%	   will execute A=C if B is true and D=E if B is false
%	   this option will run if there are no output arguments AND the expression
%	   is a string.
%
% Created by: Yanai Ankri, 30 August 2010 (BSD License)
% Modified by: Alexander Forrence, 27 April 2016 (BSD). Minor cleanup & renaming

if nargout > 0 || ~ischar(res_true) || ~ischar(res_false)
	if numel(cond) > 1
		res = zeros(size(cond));
        flag = 0;
		if (numel(res_true) == 1) || (isequal(size(cond), size(res_true)))
			res = res + res_true.*cond;
			flag = flag+  1;
		end
		if (numel(res_false) == 1) || (isequal(size(cond), size(res_false)))
			res = res + res_false.*(~cond);
			flag = flag + 1;
		end
		if flag < 2
			error('error in condition and result sizes !');
		end
	else
		if cond
			res = res_true;
		else
			res = res_false;
		end
	end
else
	if cond
		evalin('caller', res_true);
	else
		evalin('caller', res_false);
	end
end