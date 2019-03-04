% static function that converts all files
% that contain Data objects in them
% into dumps from Data that can be
% loaded using Data.load()

function convertFiles2DataFormat()

all_files = dir(pwd);

for i = 1:length(all_files)
	corelib.textbar(i,length(all_files))
	if strcmp(all_files(i).name(1),'.')
		continue
	end

	% probe for DATA_SIZE variable
	try
		vars = whos('-file',all_files(i).name);
	catch
		continue
	end

	if any(strcmp({vars.name},'DATA_SIZE'))
		continue
	end

	do_this = false(length(vars),1);
	for j = 1:length(vars)
		if strcmp(vars(j).class,'Data')
			do_this(j) = true;
		end
	end

	if ~any(do_this)
		continue
	end

	load(all_files(i).name,'-mat')

	for j = 1:length(vars)
		if ~do_this(j)
			continue
		end
		eval([vars(j).name '.save;'])
	end

	delete(all_files(i).name)

end