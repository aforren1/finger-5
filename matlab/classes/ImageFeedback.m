classdef ImageFeedback
    properties
        scale;
        img_path = 'misc/images/other/wrong.png';
        ptb_image;
    end

    methods
        function obj = ImageFeedback(scrn_handle, scrn_dims_x, varargin)
            if IsOctave
                try
                    pkg load image % make sure we have imresize
                catch ME
                    error('install image from octave-forge first!');
                end
            end
            opts = struct('scale', 0.35);
            opts = CheckInputs(opts, varargin{:});

            obj.scale = opts.scale;
            tempimg = imread(obj.img_path);
            tempimg = imresize(tempimg, [obj.scale*scrn_dims_x NaN]);
            obj.ptb_image = Screen('MakeTexture', scrn_handle, tempimg);
        end

        function DrawImageFeedback(obj, scrn_handle)
            Screen('DrawTexture', scrn_handle, obj.ptb_image,...
                   [], [], [], [], 0.5); % last term is the alpha
        end
    end
end
