% preallocate Data
% grows the data size by N
% and fills it with NaNs
% 

function prealloc(self, N)

assert(isscalar(N),'N should be a scalar')
assert(isint(N),'N should be a integer')
assert(N>1,'N should be > 1')

prop_names = self.prop_names;

real_sz = size(self.(prop_names{1}),1);

for i = 1:length(prop_names)

	self.(prop_names{i}) = vertcat(self.(prop_names{i}),NaN(N,size(self.(prop_names{i}),2)));

end
