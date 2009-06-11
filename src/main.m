test  = getData('../data/stills/plates-test.idx');
train = getData('../data/stills/plates-train.idx');

features = featureGeneration(8);

[C, alphas] = vjBoost(train, features, 10);


N = size(train.y, 2);
tp = 0; tn = 0; fp = 0; fn = 0;
for i = 1:N
	[c, v_] = strongClassify(C, alphas, train.x{i});

	% positive zone
	if (train.y(i) == 1)
		if (c == train.y(i))
			tp = tp + 1;
		else
			fp = fp + 1;
		end
	% negative zone
	else
		if (c == train.y(i))
			tn = tn + 1;
		else
			fn = fn + 1;
		end
	end
end

confusionmatrix = [tp fp; fn tn]
accuracy = (tp + tn) / N
