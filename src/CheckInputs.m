opts = CheckInputs(opts, varargin)
% all credit to 
% http://stackoverflow.com/questions/2775263/how-to-deal-with-name-value-pairs-of-function-arguments-in-matlab

%# read the acceptable names
optionNames = fieldnames(opts);

%# count arguments
nArgs = length(varargin);
if round(nArgs/2) ~= nArgs/2
   error('FUNCTION needs propertyName/propertyValue pairs')
end

for pair = reshape(varargin, 2, []) %# pair is {propName;propValue}
   inpName = lower(pair{1}); %# make case insensitive
   if any(strcmp(inpName, optionNames))
      %# overwrite opts. If you want you can test for the right class here
      %# Also, if you find out that there is an option you keep getting wrong,
      %# you can use "if strcmp(inpName, 'problemOption'),testMore,end"-statements
      opts.(inpName) = pair{2};
   else
      error('%s is not a recognized parameter name', inpName)
   end
end