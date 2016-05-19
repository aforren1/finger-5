classdef PsychImages
    properties
        raw_images; % 1xn cell array of raw images 
        ptb_images; % 1xn matrix of psychtoolbox handles
        reversed;
        scale;
    end
    
    methods
        function obj = PsychImages(n_images, varargin)
		    if IsOctave
                pkg load image % make sure we have imresize
            end
            opts = struct('reversed', false,...
                          'scale', 0.22);
            opts = CheckInputs(opts, varargin{:});
            
            obj.reversed = opts.reversed;
            obj.scale = opts.scale;
            obj.raw_images = cell(1, n_images);
            obj.ptb_images = nan(1, n_images);
        end
        
        function obj = ImportImage(obj, file_path, img_index, scrn_handle, scrn_dims_x)
            obj.raw_images{img_index} = imread(file_path);
            tempimg = imresize(obj.raw_images{img_index},...
                               [obj.scale*scrn_dims_x NaN]);
            if ~obj.reversed
                tempimg = imcomplement(tempimg);
            end
            
            obj.ptb_images(img_index) = Screen('MakeTexture', scrn_handle, tempimg);  
        end
        
        function DrawImage(obj, img_index, scrn_handle)
            Screen('DrawTexture', scrn_handle, obj.ptb_images(img_index));
        end
        
    end
end