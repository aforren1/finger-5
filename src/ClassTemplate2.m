classdef ClassTemplate2
    properties
        one;
        two;
        three;
    end
    
    methods
    
        function obj = ClassTemplate2(o, tw, th)
            obj.one = o;
            obj.two = tw;
            obj.three = th;
        end
        
        function disp(obj)
            disp(obj.one);
        end
    end
end