FEATURES    = 5;
FEATURE_GEN = 5;

close all;

%test  = getData('../data/stills/plates-test.idx');
%train = getData('../data/stills/plates-train.idx');
load('matfiles/test.mat')
load('matfiles/train.mat')

features = featureGeneration(FEATURE_GEN);

[C, alphas] = vjBoost(train, features, FEATURES)

for i = 1:length(C)
	showFeature(C{i}, i);
end


N = size(test.y, 2)
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
