% plus new data to existing data
% usage
% d.plus(new_data)

function self = plus(self, new_data)


if isstruct(new_data)
	new_prop_names = fieldnames(new_data);
	sz = NaN(length(new_prop_names),2);
	for i = 1:length(new_prop_names)
		sz(i,:) = size(new_data.(new_prop_names{i}));
	end
	new_data_size = mode(sz(:));


	% make sure all data sizes match
	for i = 1:length(self.prop_names)
		this_sz = size(self.(self.prop_names{i}),2);
		if size(new_data.(self.prop_names{i}),2) == this_sz
			% all ok
		elseif size(new_data.(self.prop_names{i}),2) ~= this_sz & size(new_data.(self.prop_names{i}),1) == this_sz
			% rotate
			new_data.(self.prop_names{i}) = transpose(new_data.(self.prop_names{i}));
		else
			error('Mismatched sizes, cannot proceed')

		end
	end

elseif  isa(new_data,'Data')
	new_prop_names = new_data.prop_names;
	new_data_size = new_data.size;
else
	error('Unknown data type')
end


assert(length(self.prop_names) == length(new_prop_names),'Data structures incongruent ')

prop_names = self.prop_names;

if length(prop_names) == 0
	return
end

for i = 1:length(prop_names)
	assert(any(strcmp(new_prop_names,prop_names{i})),'Data structures are incongruent')
end


true_sz = size(self.(prop_names{1}),1);

if true_sz == self.size
	% no buffer

	for i = 1:length(prop_names)
		self.(prop_names{i}) = vertcat(self.(prop_names{i}),new_data.(prop_names{i}));
	end

	self.size = size(self.(prop_names{1}),1);

else
	for i = 1:length(prop_names)
		self.(prop_names{i})(self.size+1:self.size+new_data_size,:) = new_data.(prop_names{i});
	end

	self.size = self.size+new_data_size;

end