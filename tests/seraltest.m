srl = serial('/dev/ttyACM0', 'BaudRate', 9600);
set(srl, 'Timeout',0.0001);
set(srl, 'InputBufferSize', 4096);
set(srl, 'ReadAsyncMode', 'continuous');
tempmat = zeros(1000,7);
fopen(srl);
for ii = 1:1000
   try
       tempmat(ii,:) = str2num(fscanf(srl));
   catch me
       me.message
   end   
end
fclose(srl);
flushinput(srl);
fopen(srl);
flushinput(srl);
aa = fscanf(srl);
fclose(srl);