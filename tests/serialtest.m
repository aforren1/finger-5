addpath(genpath('matlab'));
srl = BlamSerial('port', '/dev/ttyACM0', 'sampling_freq', 200);

endtime = WaitSecs(1.5);

tic
data = srl.ReadLines(0, 0.01);
toc
data
WaitSecs(0.016);
srl.Purge;
tic
data2 = srl.ReadLines(0, 0.02);
toc
data
srl.Close;
