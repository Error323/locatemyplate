%%%%% GLOBAL CONSTANTS %%%%%
global INTEGRALS SEGMENTS DEBUG SCALEFACTOR train test features;

% Number of integral images
INTEGRALS   = 9;

% Number of segments/blocks within a feature
SEGMENTS    = 3;

% Show debug information
DEBUG       = false;

% Scaling factor on train and test data
SCALEFACTOR = 0.5;

% % Load train data
% trainfile = sprintf('../cache/train-%0.1f.mat', SCALEFACTOR); 
% if (exist(trainfile))
% 	fprintf('\nloading %s from cache\n\n', trainfile);
% 	load(trainfile);
% else
% 	fprintf('\ngenerating and saving %s\n\n', trainfile);
% 	train = getData('../data/stills/plates-train.idx', SCALEFACTOR);
% 	save(trainfile, 'train');
% end
% 
% % Load test data
% testfile = sprintf('../cache/test-%0.1f.mat', SCALEFACTOR); 
% if (exist(testfile))
% 	fprintf('\nloading %s from cache\n\n', testfile);
% 	load(testfile);
% else
% 	fprintf('\ngenerating and saving %s\n\n', testfile);
% 	test = getData('../data/stills/plates-test.idx', SCALEFACTOR);
% 	save(testfile, 'test');
% end
% 
% % Load feature data
% featurefile = sprintf('../cache/feature-%d.mat', SEGMENTS);
% if (exist(featurefile))
% 	fprintf('\nloading %s from cache\n\n', featurefile);
% 	load(featurefile);
% else
% 	fprintf('\ngenerating and saving %s\n\n', featurefile);
% 	features = featureGeneration(SEGMENTS);
% 	for i = 1:length(features)
% 		features{i} = trainWeakClassifier(features{i}, train);
% 		fprintf('training features %0.2f%% complete\n', (i/length(features)*100));
% 	end
% 	save(featurefile, 'features');
% end
