% wrapper for octave/matlab serial ports
classdef SerialPort
    properties
        octave_or_matlab;
        baud_rate;
        port;
    end
    
    methods
        function obj = SerialPort(port, varargin)
            opts = struct('baud_rate', 9600);
            isoctave = IsOctave;
            obj.isoctave = isoctave;
            obj.baud_rate = opts.baud_rate;
            
            if isoctave % on octave
                try 
                    pkg load instrument-control
                catch ME
                    error('Install instrument-control first!');
                end
                obj.serial = serial(port, opts.baud_rate);

            else % on matlab
                if ~usejava('jvm') % not using the jvm
                    error(['jvm required for matlab serial port.\n',...
                           'Run matlab without -nojvm flag']);   
                end
                obj.serial = serial(port, 'BaudRate', opts.baud_rate);   
                fopen(obj.serial);      
            end              
        end
        
        function out = ReadSerial(obj)
            if obj.isoctave
                out = char(srl_read(obj.serial));
            else
                out = fscanf(obj.serial);
            end
        end
        
        function WriteSerial(obj, to_write)
            if ~ischar(to_write)
                error('Do not write non-strings (for now)');
            end
            
            if obj.isoctave
                srl_write(obj.serial, to_write);
            else
                fprintf(obj.serial, to_write);
            end
        end
        
        function CloseSerial(obj)      
            fclose(obj.serial);
            delete(obj.serial);          
        end
    end



end