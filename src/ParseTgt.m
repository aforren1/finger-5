function out = ParseTgt(filename)

	fid = fopen(filename, 'r');
	headerline = fgetl(fid);
	data = dlmread(filename, ',', 1, 0);
	fclose(fid);

	headers = textscan(headerline,'%s','Delimiter',',');

	for k = 1:length(headers{:})
	   eval(['out.' headers{1}{k} '= data(:,k);']);
	end

end