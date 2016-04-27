classdef KeyboardResponse < KeyResponse
    properties
       valid_keys;
       possible_keys;
    end
    
    methods
    function obj = KeyboardResponse(valid_indices, varargin)
        if ~exist('valid_indices', 'var')
            error('Need valid indices!');
        end
        
        obj@KeyResponse(valid_indices, varargin);
        opts = struct('possible_keys', {'a','w','e','f','v','b','h','u','i','l'});
        opts = CheckInputs(opts, varargin{:});
        
        obj.valid_keys = opts.possible_keys(valid_indices);
        keys = zeros(1, 256);
        %keys(KbName(obj.valid_keys)) = 1;
        %KbQueueCreate(-1, keys);

    
    end
end
end