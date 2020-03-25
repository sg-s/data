function self = struct2Data(self, S)

corelib.assert(isstruct(S),'S must be a structure')
corelib.assert(isscalar(S),'S must be a scalar structure')

fn = fieldnames(S);

for i = 1:length(fn)

	self.add(fn{i},size(S.(fn{i}),2));
	self.(fn{i}) = S.(fn{i});


end
self.size = size(S.(fn{1}),1);
