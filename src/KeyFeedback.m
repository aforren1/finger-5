classdef KeyFeedback
    properties
        n_boxes;
        outline_colour;
        correct_colour;
        incorrect_colour;
        rect_locs;
        red;
        green;
        blue;
    end
    
    methods
        function obj = KeyFeedback(dims_x, dims_y, varargin)
        
            opts = struct('n_boxes', 4,...
                          'outline_colour', [255, 255, 255],...
                          'red', [255, 30, 63],...
                          'green', [97, 255, 77],...
                          'blue', [85, 98, 255]);
            opts = CheckInputs(opts, varargin{:});
            obj.n_boxes = opts.n_boxes;
            obj.outline_colour = opts.outline_colour;
            obj.red = opts.red;
            obj.green = opts.green;
            obj.blue = opts.blue;
            
            spacing = linspace(0.2, 0.8, obj.n_boxes);
            rect_area = (spacing(2) - spacing(1))/2;
            base_rect = rect_area * [0 0 dims_x dims_x];
            xrectpos = spacing * dims_x;
            yrectpos = 0.8 * dims_y * ones(1, length(spacing));

            obj.rect_locs = nan(4, opts.n_boxes);
            for pp = 1:length(yrectpos)
                obj.rect_locs(:,pp) = CenterRectOnPointd(base_rect,...
                xrectpos(pp), yrectpos(pp));
            end
        end % end constructor
        
        function DrawOutline(obj, scrn)
            if ~isa(scrn, 'PsychScreen') 
                error('Wrong class')
            end
            Screen('FrameRect', scrn.window,...
                   obj.outline_colour, obj.rect_locs);
        end
        
        function DrawFill(obj, scrn, colour, indices)
            if ~isa(scrn, 'PsychScreen')
                error('Wrong class')
            end
            which_colour = getfield(obj, colour);
            Screen('FillRect', scrn.window,...
                   which_colour, obj.rect_locs(:, find(indices > 0)));
        end
    end % end methods
end % end classdef