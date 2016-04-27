classdef fruit
    properties
        colour;
        shape;
    end
    methods
        function out = fruit(varargin)
            opts = struct('colour', [],...
                          'shape', []);
            opts = CheckInputs(opts, varargin{:});
            out.colour = opts.colour;
            out.shape = opts.shape;
        end
        function printme(obj)
            disp(obj.colour);
        end
    end
    
end