addpath(genpath('matlab'));
srl = BlamSerial('port', '/dev/ttyACM0', 'sampling_freq', 200);

endtime = WaitSecs(0.010);

tic
data = srl.ReadLines(0.01);
toc
WaitSecs(0.016);

tic
data = srl.ReadLines(0.02);
toc
srl.Close;
