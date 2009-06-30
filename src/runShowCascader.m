clear
globals;

% Load train data
trainfile = sprintf('../cache/test-%0.1f.mat', SCALEFACTOR); 
if (exist(trainfile))
	fprintf('\nloading %s from cache\n\n', trainfile);
	load(trainfile);
else
	fprintf('\ngenerating and saving %s\n\n', trainfile);
	test = getData('../data/stills/plates-test.idx', SCALEFACTOR);
	save(trainfile, 'test');
end

cascader = load('../cache/cascader.mat');

showCascader(cascader.cascader, test,0 ,0);
