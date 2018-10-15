% makes a new Data structure 
% with the same fields
% but with no data

function new_self = new(self)


new_self = Data();

for i = 1:length(self.prop_names)

	new_self.add(self.prop_names{i},size(self.(self.prop_names{i}),2));

end
