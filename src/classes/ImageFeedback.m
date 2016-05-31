classdef ImageFeedback
    properties
        scale;
        img_path;
        ptb_image;
    end
    
    methods
        function obj = ImageFeedback(scrn_handle, scrn_dims_x, varargin)
            if IsOctave
                pkg load image;
            end
            opts = struct('scale', 0.35);
            opts = CheckInputs(opts, varargin{:});
            
            obj.scale = opts.scale;
            obj.img_path = 'misc/images/other/wrong.png';
            tempimg = imread(obj.img_path);
            tempimg = imresize(tempimg, [obj.scale*scrn_dims_x NaN]);
            obj.ptb_image = Screen('MakeTexture', scrn_handle, tempimg);
        end
        
        function DrawImageFeedback(obj, scrn_handle)
            Screen('DrawTexture', scrn_handle, obj.ptb_image,...
                   [], [], [], [], 0.5);
        end
    end
end
            