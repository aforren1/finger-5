classdef BlamShape > Rainbow & SuperHandle

    properties
        outline;
        outline_thickness;

    methods
        function Draw() end
        function Close(o)
            delete(o);
        end
    end
end
