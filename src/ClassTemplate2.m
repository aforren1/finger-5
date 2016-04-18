classdef ClassTemplate2
    properties
        one;
        two;
        three;
        p1;
        p2;
    end
    
    methods
    
        function obj = ClassTemplate2(o, tw, th, varargin)
            opts = struct('p1', 33, 'p2', 'test');
            opts = CheckInputs(opts, varargin{:}); % this pattern ought to be pretty constant
            obj.p1 = opts.p1;
            obj.p2 = opts.p2;
            obj.one = o;
            obj.two = tw;
            obj.three = th;
            
        end
        
        function disp(obj)
            disp(obj.p1);
        end
    end
end