classdef BlamScreen < SuperHandle & Rainbow
    properties
        reversed; % reversed == true == white background
        background_colour;
        text_colour;
        center_x;
        center_y;
        window; % The thing referred to by `Flip()` and co.
        dims; % dimensions of the window
        priority; % highest priority possible for screen
        ifi; % interflip interval
    end % end properties

    methods
        function obj = BlamScreen(varargin)
        % Additional settings are `big_screen` and `skip_tests`
            AssertOpenGL;
            screens = Screen('Screens');
            scrn_num = max(screens);
            opts = struct('reversed', false,...
                          'big_screen', false,...
                          'skip_tests', true);
            opts = CheckInputs(opts, varargin{:});
            obj.reversed = opts.reversed;

            if opts.skip_tests
                Screen('Preference', 'SkipSyncTests', 1);
                Screen('Preference', 'SuppressAllWarnings', 1);
            end

            if opts.reversed
                obj.background_colour = obj.white;
                obj.text_colour = obj.black;
            else
                obj.background_colour = obj.black;
                obj.text_colour = obj.white;
            end

            if opts.big_screen % big screen
                [obj.window, obj.dims] = Screen('OpenWindow', scrn_num,...
                                                 obj.background_colour);
            else
                [obj.window, obj.dims] = Screen('OpenWindow', scrn_num,...
                                                 obj.background_colour,...
                                                 [200 200 600 600]);
            end

            [obj.center_x, obj.center_y] = RectCenter(obj.dims);
            obj.dims = obj.dims(3:4);
            Screen('BlendFunction', obj.window, ...
                   'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
            obj.priority = MaxPriority(obj.window);
            obj.ifi = Screen('GetFlipInterval', obj.window);

        end % end BlamScreen

        function CloseScreen(obj)
            sca;
            delete(obj); % only matlab obeys this!
        end

        function WipeScreen(obj)
            Screen('FillRect', obj.window, obj.background_colour);
        end

        function FillScreen(obj, colour)
            Screen('FillRect', obj.window, obj.(colour));
        end

        function out_time = FlipScreen(screen, flip_time)
            if nargin < 2
                flip_time = 0;
            end
            out_time = Screen('Flip', screen.window, flip_time);
        end

    end % end methods
end % end classdef
