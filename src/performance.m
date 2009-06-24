FEATURES = 2;
SEGMENTS = 2;

close all;

% Obtain test data
if (exist('../cache/test.mat', 'file'))
	load('../cache/test.mat');
else
	test  = getData('../data/stills/plates-test.idx', 1);
	save('../cache/test.mat', 'test');
end

% Obtain train data
if (exist('../cache/train.mat', 'file'))
	load('../cache/train.mat');
else
	train = getData('../data/stills/plates-train.idx', 1);
	save('../cache/train.mat', 'train');
end



% Obtain the features
if (exist('../cache/features.mat', 'file'))
	load('../cache/features.mat');
else
	features   = featureGeneration(SEGMENTS);

	% Train all the weak classifiers
	pos = length(find(train.y == 1));
	neg = length(find(train.y == 0));
	for h = 1:length(features)
		features{h} = trainWeakClassifier(features{h}, train, neg, pos);
		fprintf('training: %0.2f%% complete\n', h/length(features)*100);
	end
	save('../cache/features.mat', 'features');
end

nrfeatures = length(features)

[C, alphas] = vjBoost(train, features, FEATURES);

for i = 1:length(C)
	showFeature(C{i}, i);
end


N = length(test.y);
tp = 0; tn = 0; fp = 0; fn = 0;
for i = 1:N
	[c, v_] = strongClassify(C, alphas, test.x{i}, 0.5);

	% positive zone
	if (test.y(i) == 1)
		if (c == test.y(i))
			tp = tp + 1;
		else
			fp = fp + 1; % rejection while true
		end
	% negative zone
	else
		if (c == test.y(i))
			tn = tn + 1;
		else
			fn = fn + 1; % fails to reject while false
		end
	end
end

confusionmatrix = [tp fp; fn tn]
accuracy        = (tp + tn) / N
recall          = tp / (tp + fp)
precision       = tp / (tp + fn)
