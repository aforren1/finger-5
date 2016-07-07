addpath(genpath('matlab'));
srl = BlamSerial('port', '/dev/ttyACM0', 'sampling_freq', 200);

endtime = WaitSecs(2);

data = srl.ReadLines;
srl.Close;
