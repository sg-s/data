% a data class
% which makes it easy to work with datasets
% in matlab
% Srinivas Gorur-Shandilya
% 
% data is really just a structure
% with a bunch of helper functions 
% it is assumed that all your data will be 2D at most
% and you will use logical indexing to pull out
% chunks of data

classdef Data < dynamicprops


	properties
		size
	end

	properties (Access =  private)
		input_names
	end



	methods
		% constructor function -- makes a data object
		% from a bunch of compatibly sized matrices and vectors
		function self = Data(varargin)
			self.input_names = {};
			for i = length(varargin):-1:1
				self.input_names{i} = inputname(i);
			end
			self = self.add(varargin{:});
			self.input_names = {};

			
		end % end constructor


		function self = add(self, varargin)

			% determine the input names
			if isempty(self.input_names)
				for i = length(varargin):-1:1
					input_names{i} = inputname(i+1);
				end

			else
				input_names = self.input_names;
			end

			% check that all varargins have the same size
			for i = 1:length(varargin)
				this_sz = size(varargin{i});
				if length(this_sz) > 2
					error('Only 1D and 2D matrices are supported')
				end

				sz(:,i) = this_sz;
			end

			self.size = mode(sz(:));
			assert(min(sum(sz == mode(sz(:)))) == 1,'Data sizes inconsistent')
			for i = 1:length(varargin)
				self.addprop(input_names{i});
				if isvector(varargin{i})
					self.(input_names{i}) = varargin{i}(:);
				else
					if size(varargin{i},2) ~= self.size
						varargin{i} = varargin{i}';
					end
					self.(input_names{i}) = varargin{i};
				end
			end
			self.input_names = {};

			% overwrite the variable in the calling workspace
			if nargout == 0
				assignin('caller',inputname(1),self)
			end
		end % end add

	end % end methods

end % end classdef