% clears all data
% but preserves the arrays
% basically fills everything with NaN
% and resets the size indicator
%

function reset(self)

prop_names = self.prop_names;

for i = 1:length(prop_names)
	self.(prop_names{i}) = self.(prop_names{i})*NaN;
end

self.size = 0;