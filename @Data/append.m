% append new data to existing data
% usage
% d.append(new_data)

function append(self, new_data)

assert(length(self.prop_names) == length(new_data.prop_names),'Data structures incongruent ')

prop_names = self.prop_names;

for i = 1:length(prop_names)
	assert(any(strcmp(new_data.prop_names,prop_names{i})),'Data structures are incongruent')
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
		self.(prop_names{i})(self.size+1:self.size+new_data.size,:) = new_data.(prop_names{i});
	end

	self.size = self.size+new_data.size;

end