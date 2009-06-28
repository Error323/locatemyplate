%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% trainWeakClassifier(feature, data, m, l)
%%
%% INPUTS:
%%  - feature, the current feature being trained
%%  - data, [I, P, N, D]
%%
%% OUPUTS:
%%  - feature, sets the threshold and wether its a positive
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function feature = trainWeakClassifier(feature, data)
	global INTEGRALS DEBUG
	I = data.I;
	P = data.P;
	N = data.N;
	D = data.D;

	values = []; signs = [];
	R = {};
	for i=1:length(I)
		[C_, R_, V] = weakClassify(feature, D{i}, I{i}{feature.int}, R);
		[v_, idx]   = find(P{i} == 1);
		pos         = V(idx);
		[v_, idx]   = find(N{i} == 1);
		neg         = V(idx);
		neg         = neg(randi(length(neg), 1, min(length(neg),50)));
		values      = [values neg' pos];
		signs       = [signs zeros(1,length(neg)) 1];
	end

	[v_, IDX] = sort(values);
	signs     = signs(IDX);
	values    = values(IDX);
	l         = length(find(signs == 1));
	m         = length(find(signs == 0));

	iStar    = 1;
	best     = 0;
	positive = true;

	for i = 2:length(values)-1
		posLeft  = length(find(signs(1:i) == 1));
		posRight = l - posLeft;
		negLeft  = length(find(signs(1:i) == 0));
		negRight = m - negLeft;

		% thresholding <
		if (posLeft/l >= negLeft/m)
			v = posLeft/l + negRight/m;
			if (v > best)
				best     = v;
				iStar    = i;
				positive = false;
			end

		% thresholding >
		else
			v = posRight/l + negLeft/m;
			if (v > best)
				best     = v;
				iStar    = i;
				positive = true;
			end
		end
	end

	feature.threshold = values(iStar);
	feature.positive  = positive;

	if (false)
		IDX = find(signs == 1);
		discriminant = ones(1,length(values))*feature.threshold;
		plot(values(IDX), '*');
		hold on;
		plot(discriminant, 'r');
		IDX = find(signs == 0);
		plot(values(IDX), '.', 'MarkerEdgeColor', 'g');
		hold off;
		pause(5);
	end
end
