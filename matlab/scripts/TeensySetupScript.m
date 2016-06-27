% separate out all the messy logic
if isunix
    src_path = ['"$(pwd)/platformio/', ui.exp_type,'_src"'];
else
    % untested!
    src_path = ['%cd%\platformio\', ui.exp_type, '_src'];
end
setenv('PLATFORMIO_SRC_DIR', src_path);
system('platformio run --target clean -v');
working_serial = ~system('platformio run -e teensy31 -v');
working_serial = ~system('platformio run -e teensy31 --target upload -v');
if working_serial
    % set up serial connection here: how to detect the right one??
    srl = SerialPort(consts.serialport);
else
    warning('Teensy failed for some reason (printed above?)!');
    warning('Will ignore the serial port in the experiment...');
end
