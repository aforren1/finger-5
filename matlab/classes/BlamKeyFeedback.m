classdef BlamKeyFeedback < SuperHandle & Rainbow
    properties
        num_boxes;
        outline_colour;
        rect_locs;
    end

    methods
        function obj = BlamKeyFeedback(dims_x, dims_y, varargin)

            opts = struct('num_boxes', 4, 'reversed', false);
            opts = CheckInputs(opts, varargin{:});
            obj.num_boxes = opts.num_boxes;
            obj.outline_colour = ifelse(opts.reversed, obj.black, obj.white);

            spacing = linspace(0.18, 0.82, obj.num_boxes);
            rect_area = (spacing(2) - spacing(1))/2;
            base_rect = rect_area * [0 0 dims_x dims_x];
            xrectpos = spacing * dims_x;
            yrectpos = 0.8 * dims_y * ones(1, length(spacing));

            obj.rect_locs = nan(4, opts.num_boxes);
            for pp = 1:length(yrectpos)
                obj.rect_locs(:,pp) = CenterRectOnPointd(base_rect,...
                xrectpos(pp), yrectpos(pp));
            end
        end % end constructor

        function DrawOutline(obj, window)
            Screen('FrameRect', window, obj.outline_colour, obj.rect_locs);
        end

        function DrawFill(obj, window, colour, indices, scale)
        % obj is of KeyFeedback class
        % window is scrn.window
        % colour is a string (eg. 'red', 'blue', 'green')
        % indices is a misnomer, usually of the form [0 1 0 .5]
        % scale is a fixed amount to scale the squares by
        % (0 being no change, .5 being 50% smaller)
        box_rescale = [1; 1; -1; -1] * ...
                (obj.rect_locs(3,1) - obj.rect_locs(1,1)) * scale;

        Screen('FillRect', window, get(obj, colour), ...
               obj.rect_locs(:, find(indices > 0)) + box_rescale);
        end
    end % end methods
end % end classdef
