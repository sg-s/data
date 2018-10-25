% makes a new data structure
% filled with NaNs
function new_self = placeholder(self)


S = structure(self);

fn = fieldnames(S);

for i = 1:length(fn)
	S.(fn{i})(1,:) = NaN;
end

new_self = Data(S);
