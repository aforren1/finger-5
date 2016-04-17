function output = FunctionTemplate(req, varargin)
% http://stackoverflow.com/questions/2775263/how-to-deal-with-name-value-pairs-of-function-arguments-in-matlab
% for light reading about multiple (optional and required) args

    % default parameter/value pairs
    opts = struct('param1', 33, 'param2', 'test');
    opts = CheckInputs(opts, varargin{:}); % this pattern ought to be pretty constant
    output = opts;
    output.req = req;
    output.f.GetReq = @GetReq;
end

function output = GetReq(obj)
    output = obj.req;
end