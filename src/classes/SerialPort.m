% wrapper for octave/matlab serial ports
classdef SerialPort
    properties
        serial;
        isoctave;
        baud_rate;
        port;
    end
    
    methods
        function obj = SerialPort(port, varargin)
            opts = struct('baud_rate', 9600);
            isoctave = IsOctave;
            obj.isoctave = isoctave;
            obj.baud_rate = opts.baud_rate;
            obj.port = port;
            
            if isoctave % on octave
                try 
                    pkg load instrument-control
                catch ME
                    error('Install instrument-control first!');
                end
                obj.serial = serial(port, opts.baud_rate);
                set(obj.serial, 'timeout', 0.1); % in tenths of a sec??

            else % on matlab
                if ~usejava('jvm') % not using the jvm
                    error(['jvm required for matlab serial port.\n',...
                           'Run matlab without -nojvm flag']);   
                end
                obj.serial = serial(port, 'BaudRate', opts.baud_rate);
                set(obj.serial, 'Timeout', 0.001); 
                fopen(obj.serial);      
            end              
        end
        
        function out = ReadSerial(obj)
            % both return single line now, how to read until
            % no new line?
            if obj.isoctave
                out = ReadLine(obj);
            else
                out = fscanf(obj.serial);
            end
        end
        
        function out = ReadLine(obj)
            not_done = true;
            ii = 1;
            int_array = uint8(1);
            
            while not_done
                val = srl_read(obj.serial, 1);        
                if val == 10 % newline
                    not_done = false;
                end        
                int_array(ii) = val;
                ii = ii + 1;
            end
            out = char(int_array);     
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
        
        function FlushSerial(obj)
            if obj.isoctave
                srl_flush(obj.serial);
            else
                flushinput(obj.serial);
            end
        
        end
        
        function CloseSerial(obj)      
            fclose(obj.serial);
        end
    end



end