function save(self,save_name)

if nargin == 1
	% no save name, make one up from a 
	% hash of the data in here

	for i = length(self.prop_names):-1:1
		H{i} = mtools.crypto.md5hash(self.(self.prop_names{i}));
	end
	save_name = [mtools.crypto.md5hash(vertcat(H{:})) '.data'];

end

% disp('using matfile')
% tic
% m = matfile('matfile.mat','Writable',true);
% for i = 1:length(self.prop_names)
% 	m.(self.prop_names{i}) = self.(self.prop_names{i});
% end
% toc

% using an eval and save (yes, ugly code)
% is 100X times faster than matfile
% disp('using simple save')

for i = 1:length(self.prop_names)
	 eval([self.prop_names{i} '=self.(self.prop_names{i});']);
end
DATA_SIZE = self.size;
save(save_name,self.prop_names{:},'DATA_SIZE','-v7.3','-nocompression')
