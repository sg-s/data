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


	properties (SetAccess = protected)
		size = 0;
	end

	properties (Access =  private)
		input_names
		prop_names = {};
	end



	methods
		% constructor function -- makes a data object
		% from a bunch of compatibly sized matrices and vectors
		function self = Data(varargin)
			if nargin == 0
				return
			end

			if nargin == 1 & isstruct(varargin{1})
				disp('Converting matlab struct to Data structure')

				S = varargin{1};

				if length(S) == 1
					disp('Scalar structure...')
					fn = fieldnames(S);
					sz = size(S.(fn{1}));
					for i = 2:length(fn)
						assert(all(size(S.(fn{i})) == sz),'Mismatched fields, cannot be made into a data structure');
					end
					for i = 1:length(fn)
						prop_handle = self.addprop(fn{i});
						prop_handle.SetAccess = 'protected';
						self.prop_names = vertcat(self.prop_names, fn{i});
						self.(fn{i}) = S.(fn{i});
					end

				else
					disp('vector structure, not coded...')
					keyboard
				end

				self.size = max(sz);

				return


			elseif nargin == 1 & exist(varargin{1},'file') == 2
				disp('Converting file to Data structure')
				matfile_handle = matfile(varargin{1});
				vars = whos(matfile_handle);
				sz = vertcat(vars.size);
				sz = mode(sz(:,1));
				% check that all variables are the same size
				for i = 1:length(vars)
					assert(length(vars(i).size)<3,'3+ dimension matrix exists in this file, cannot be made into a Data structure')
					assert(vars(i).size(1) == sz || vars(i).size(2) == sz ,'[FATAL] Mismatched array sizes')

				end

				for i = 1:length(vars)
					prop_handle = self.addprop(vars(i).name);
					prop_handle.SetAccess = 'protected';
					self.prop_names = vertcat(self.prop_names, vars(i).name);

					if vars(i).size(2) == 2
						temp = matfile_handle.(vars(i).name);
						self.(vars(i).name) = temp';
					else
						self.(vars(i).name) = matfile_handle.(vars(i).name);
					end
				end

				self.size = sz;
				return

			else

				self.input_names = {};
				for i = length(varargin):-1:1
					self.input_names{i} = inputname(i);
				end
				self = self.add(varargin{:});
				self.input_names = {};
			end

			
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
						varargin{i} = transpose(varargin{i});
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