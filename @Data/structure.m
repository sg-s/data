% returns a structure that corresponds
% to an empty version of this dataset
% useful for appending to the dataset
% 
function S = structure(self)

S = struct;
temp = self.new();
for i = 1:length(self.prop_names)
	S.(self.prop_names{i}) = temp.(self.prop_names{i});
end
