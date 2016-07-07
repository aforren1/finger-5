addpath(genpath('matlab'));
srl = BlamSerial('port', '/dev/ttyACM0', 'sampling_freq', 200);

endtime = WaitSecs(0.010);

tic
data = srl.ReadLines;
toc
WaitSecs(0.02);

tic
data = srl.ReadLines;
toc
srl.Close;
