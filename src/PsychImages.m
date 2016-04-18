classdef PsychImages
    properties
        raw_images; % cell array of raw images 
        ptb_images; % 1xn matrix of psychtoolbox handles
        reversed;
        scale;
    end
    
    methods
        function obj = PsychImages(n_images, varargin)
            opts = struct('reversed', false,...
                          'scale', 0.22);
            opts = CheckInputs(opts, varargin{:});
            
            obj.reversed = opts.reversed;
            obj.scale = opts.scale;
            obj.raw_images = cell(1, n_images);
            obj.ptb_images = nan(1, n_images);
        end
        
        function obj = ImportImages(obj, file_path, idx, scrn)
            
            obj.raw_images{idx} = imread(file_path);
            tempimg = imresize(obj.raw_images{idx},...
                               [obj.scale*scrn.dims(3) NaN]);
            if ~obj.reversed
                tempimg = imcomplement(tempimg);
            end
            
            obj.ptb_images(idx) = Screen('MakeTexture', scrn.window, tempimg);  
        end
    end
end