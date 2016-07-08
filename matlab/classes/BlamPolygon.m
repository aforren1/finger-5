classdef BlamPolygon > BlamShape
    properties
        vertices_x; % vector of x positions (scaled from 0 to 1)
        vertices_y;
    end

    methods
        function obj = BlamPolygon(vertices_x, vertices_y, varargin)
            obj.verices_x = verices_x;
            obj.vertices_y = vertices_y;
        end
        function Draw(o)

        end
    end
end
