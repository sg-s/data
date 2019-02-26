% add()
% add variable to Data structure
% 
function add(self, varargin)



for ii = 1:2:length(varargin)-1
		
	var_name = varargin{ii};
	var_size = varargin{ii+1};

	% check that this doesn't alreay exist 
	assert(~any(strcmp(self.prop_names,var_name)),'Variable name already exists')
	assert(isscalar(var_size),'Varible size must be a scalar')
	assert((var_size>0),'Varible size must be positive')
	assert(mathlib.isint(var_size),'Varible size must be a integer')

	self.prop_names = vertcat(self.prop_names,var_name);
	prop_handle = self.addprop(var_name);
	prop_handle.SetAccess = 'protected';
	self.(var_name) = NaN(self.size,var_size);

end







