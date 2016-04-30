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
                          'reversed', false,...
                          'red', [255, 30, 63],...
                          'green', [97, 255, 77],...
                          'blue', [85, 98, 255]);
            opts = CheckInputs(opts, varargin{:});
            obj.n_boxes = opts.n_boxes;
            obj.outline_colour = ifelse(opts.reversed, [0 0 0], [255 255 255]);
            obj.red = opts.red;
            obj.green = opts.green;
            obj.blue = opts.blue;
            
            spacing = linspace(0.15, 0.85, obj.n_boxes);
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
        
        function DrawOutline(obj, window)
            Screen('FrameRect', window,...
                   obj.outline_colour, obj.rect_locs);
        end
        
        function DrawFill(obj, window, colour, indices, scale)
        % obj is of KeyFeedback class 
        % window is scrn.window
        % colour is a string (eg. 'red', 'blue', 'green')
        % indices is a misnomer, usually of the form [0 1 0 .5]
        % scale is a fixed amount to scale the squares by
            which_colour = getfield(obj, colour);
            box_rescale = [1; 1; -1; -1] * ...
                    (obj.rect_locs(3,1) - obj.rect_locs(1,1))*scale);
                    
            Screen('FillRect', window, which_colour, ...
                   obj.rect_locs(:, find(indices > 0)) + box_rescale);
        end
    end % end methods
end % end classdef