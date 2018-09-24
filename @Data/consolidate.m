function consolidate(self, look_here)

if nargin == 1
	look_here = pwd;
end

all_files = dir([look_here filesep '*.data']);

if length(all_files) == 0
	return
end

% read the sizes of all files
total_size = 0;
for i = 1:length(all_files)
	load([all_files(i).folder filesep all_files(i).name],'-mat','DATA_SIZE')
	total_size = total_size + DATA_SIZE;
end

self.prealloc(total_size)


for i = 1:length(all_files)
	textbar(i,length(all_files))
	d = Data([all_files(i).folder filesep all_files(i).name]);
	self + d;
end

% save this -- only if there are multiple files
if length(all_files) == 1
	return
end

self.save;

% delete all old files
for i = 1:length(all_files)
	delete([all_files(i).folder filesep all_files(i).name])
end