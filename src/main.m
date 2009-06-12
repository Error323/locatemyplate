FEATURES    = 3;
FEATURE_GEN = 8;

close all;

% Obtain test data
if (exist('matfiles/test.mat', 'file'))
	load('matfiles/test.mat');
else
	test  = getData('../data/stills/plates-test.idx', 4);
	save('matfiles/test.mat', 'test');
end

% Obtain train data
if (exist('matfiles/train.mat', 'file'))
	load('matfiles/train.mat');
else
	train = getData('../data/stills/plates-train.idx', 1);
	save('matfiles/train.mat', 'train');
end



if (exist('matfiles/features.mat', 'file'))
	load('matfiles/features.mat');
else
	% Obtain the features
	features   = featureGeneration(FEATURE_GEN);

	% Train all the weak classifiers
	pos = length(find(train.y == 1));
	neg = length(find(train.y == 0));
	for h = 1:length(features)
		features{h} = trainWeakClassifier(features{h}, train, neg, pos);
		fprintf('training: %0.2f%% complete', h/length(features)*100);
	end
	save('matfiles/features.mat', 'features');
end

nrfeatures = length(features)

[C, alphas] = vjBoost(train, features, FEATURES);

for i = 1:length(C)
	showFeature(C{i}, i);
end


N = length(test.y);
tp = 0; tn = 0; fp = 0; fn = 0;
for i = 1:N
	[c, v_] = strongClassify(C, alphas, test.x{i});

	% positive zone
	if (test.y(i) == 1)
		if (c == test.y(i))
			tp = tp + 1;
		else
			fn = fn + 1;
		end
	% negative zone
	else
		if (c == test.y(i))
			tn = tn + 1;
		else
			fp = fp + 1;
		end
	end
end

confusionmatrix = [tp fp; fn tn]
accuracy        = (tp + tn) / N
positive        = tp / (tp + fn)
negative        = tn / (tn + fp)