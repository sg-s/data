function self = consolidate(self, look_here)

if nargin == 1
	look_here = pwd;
end

all_files = dir(pathlib.join(look_here, '*.data'));

if length(all_files) == 0
	return
end


% read the sizes of all files

var_names1 = whos('-file',[all_files(1).folder filesep all_files(1).name]);
var_names1 = [var_names1.name];
load([all_files(1).folder filesep all_files(1).name],'-mat','DATA_SIZE')
total_size = DATA_SIZE;

for i = 2:length(all_files)
	var_names = whos('-file',[all_files(i).folder filesep all_files(i).name]);
	load([all_files(i).folder filesep all_files(i).name],'-mat','DATA_SIZE')
	total_size = total_size + DATA_SIZE;
	corelib.assert(strcmp([var_names.name],var_names1),'variable names do not match; consolidate cannot proceed')
end


var_names1 = whos('-file',[all_files(1).folder filesep all_files(1).name]);
var_names1(strcmp({var_names1.name},'DATA_SIZE')) = [];

inputs = cell(length(var_names1)*2,1);
inputs(1:2:end) = {var_names1.name};
inputs(2:2:end) = {var_names1.size(:,2)};

self = Data(inputs{:});


self.prealloc(total_size)



fn = {var_names1.name};


for i = 1:length(all_files)
	corelib.textbar(i,length(all_files))

	d = self.new;

	load_me = load(pathlib.join(all_files(i).folder, all_files(i).name),'-mat');
	for j = 1:length(fn)
		d.(fn{j}) = load_me.(fn{j});
	end
	d.size = load_me.DATA_SIZE;

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