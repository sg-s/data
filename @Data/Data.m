% a class that makes it easy to use datasets in MATLAB
% usage
% Data()
% Data(/path/to/data)
% Data(X) % X is a matrix
% Data(S) % S is a structure
% Data(X,Y,...) % X, Y... are matrices
% Data('var1',Size1, 'var2', Size2....) 

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

		function self = Data(varargin)

			if nargin == 0
				% do nothing
				return
			elseif  nargin == 1 && ischar(varargin{1}) && exist(varargin{1},'dir') == 7
				% load data from files
				self = self.consolidate(varargin{1});
				return

			elseif nargin == 1 && ischar(varargin{1}) && exist(varargin{1},'file') == 2
				keyboard
				return
			elseif nargin == 1 && isstruct(varargin{1})
				self = self.struct2Data(varargin{1});
				return
			else 


				% assume it is name-value syntax
				self.add(varargin{:});
				return
			end



			
		end % end constructor



	end % end methods

end % end classdef