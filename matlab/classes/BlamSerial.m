% Wrapper for SerialIO from PTB
classdef BlamSerial < SuperHandle

    properties
        port;
        baud = 9600;
        terminator = 10; % \n
        receive_timeout = 0.1;
        sampling_freq = 400;
        max_line = 30; % bytes (1 byte per ascii char?)
        read_buffer;
    end

    methods
        function obj = BlamSerial(varargin)
            opts = struct('port', '', ...
                          'baud', 9600, ...
                          'terminator', 10, ...
                          'receive_timeout', 0.1, ...
                          'sampling_freq', 400, ...
                          'max_line', 30);
            opts = CheckInputs(opts, varargin{:});
            obj.port = opts.port;
            obj.baud = opts.baud;
            obj.terminator = opts.terminator;
            obj.receive_timeout = opts.receive_timeout;
            obj.sampling_freq = opts.sampling_freq;
            obj.max_line = opts.max_line;

            if isempty(obj.port)
                obj.port = FindSerialPort([], 1);
            end

            % two minutes' worth of buffer
            obj.read_buffer = opts.max_line * opts.sampling_freq * 120;

            port_settings = sprintf('BaudRate=%i InputBufferSize=%i Terminator=%i ReceiveTimeout=%f',...
                                     obj.baud, obj.read_buffer, obj.terminator, obj.receive_timeout);
            async_settings = sprintf('BlockingBackgroundRead=1 ReadFilterFlags=4 StartBackgroundRead=%i', obj.max_line);
            obj.port = IOPort('OpenSerialPort', obj.port, port_settings);
            IOPort('ConfigureSerialPort', obj.port, async_settings);

        end

        function data = Read(o, async)
            [data, timestamp] = IOPort('Read', o.port, async, o.max_line);
            data = [timestamp, sscanf(char(data), '%d')'];
        end

        function data = ReadLines(o, secs)
            stop_time = GetSecs;
            % allocate data based on expected runtime, plus fudge factor
            data = zeros(secs * o.sampling_freq + 20, 10);
            counter = 1;
            timestamp = 0;
            while timestamp < stop_time
                [temp_dat, timestamp] = IOPort('Read', o.port, 0, o.max_line);
                data(counter, 1) = timestamp;
                temp_dat = sscanf(char(temp_dat), '%d')';
                data(counter, 2:(size(temp_dat, 2) + 1)) = temp_dat;
                counter = counter + 1;
            end
            % prune missing data
            data(all(data == 0, 2), :) = [];
            data(:, all(data == 0, 1)) = [];
        end

        function Close(o)
            IOPort('ConfigureSerialPort', o.port, 'StopBackgroundRead');
            IOPort('Close', o.port);
            delete(o);
        end
    end


end
