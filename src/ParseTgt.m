function out = ParseTgt(filename)
% filename must be the full (relative) path to the .tgt file 
% also assumes comma-delimited
	fid = fopen(filename, 'r');
	headerline = fgetl(fid);
	data = dlmread(filename, ',', 1, 0);
	fclose(fid);

	headers = textscan(headerline,'%s','Delimiter',',');
	headers = headers{1};
	
	for ii = 1:length(headers)
	    out.(headers{ii}) = data(:, ii);
	end
end