function load(self, file_name)

assert(self.size == 0,'Data can only be loaded into empty Data objects')

matfile_handle = matfile(file_name);
vars = whos(matfile_handle);

% check if this was a dump from Data.save()
if ~any(strcmp({vars.name},'DATA_SIZE'))
	error('This is not a Data dump. Cannot load from this')
end

% load data directly into the object 
for i = 1:length(vars)
	if strcmp(vars(i).name,'DATA_SIZE')
		self.size = matfile_handle.DATA_SIZE;
		continue
	end

	prop_handle = self.addprop(vars(i).name);
	prop_handle.SetAccess = 'protected';
	self.(vars(i).name) = matfile_handle.(vars(i).name);
	self.prop_names = vertcat(self.prop_names,vars(i).name);
end