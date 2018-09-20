function filtered_data = filter(self, logical_filter)

% first make a new Data object

filtered_data = self.new();

prop_names = self.prop_names;

for i = 1:length(self.prop_names)
	filtered_data.(prop_names{i}) = self.(prop_names{i})(logical_filter,:);
end

filtered_data.size = sum(logical_filter);