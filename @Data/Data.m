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


	methods (Static)
		convertFiles2DataFormat;

	end


	methods
		% constructor function -- makes a data object
		% from a bunch of compatibly sized matrices and vectors
		function self = Data(varargin)
			if nargin == 0
				return
			end

			if nargin == 1 & isstruct(varargin{1})
				S = varargin{1};

				if length(S) == 1
					fn = fieldnames(S);
					sz = NaN(length(fn),2);
					for i = 1:length(fn)
						sz(i,:) = size(S.(fn{i}));
					end
					data_size =  mode(sz(:));
					for i = 1:length(fn)
						prop_handle = self.addprop(fn{i});
						prop_handle.SetAccess = 'protected';
						self.prop_names = vertcat(self.prop_names, fn{i});
						if size(S.(fn{i}),1) == data_size
							self.(fn{i}) = S.(fn{i});
						elseif size(S.(fn{i}),2) == data_size
							self.(fn{i}) = S.(fn{i})';
						else
							error('Mismatched sizes')
						end
					end

				else
					disp('vector structure, not coded...')
					keyboard
				end

				self.size = data_size;

				return


			elseif nargin == 1 & exist(varargin{1},'file') == 2
				matfile_handle = matfile(varargin{1});
				vars = whos(matfile_handle);

				% check if this was a dump from Data.save()
				if any(strcmp({vars.name},'DATA_SIZE'))
					% it is, use Data.load()
					self.load(varargin{1})
					return
				end

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
				% attempt to use add() to make a data structure
				self.add(varargin{:})
			end

			
		end % end constructor



	end % end methods

end % end classdef