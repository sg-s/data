function filtered_data = filter(self, logical_filter)

% first make a new Data object

filtered_data = self.new();

prop_names = self.prop_names;

for i = 1:length(self.prop_names)
	filtered_data.(prop_names{i}) = self.(prop_names{i})(logical_filter,:);
end

if islogical(logical_filter) & length(logical_filter) == self.size

	filtered_data.size = sum(logical_filter);
else
	filtered_data.size = length(logical_filter);
end