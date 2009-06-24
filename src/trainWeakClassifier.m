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

	for i=1:length(I)
		for j=2:INTEGRALS
			R{i}{j} = {};
		end
	end

	values = []; signs = [];
	for i=1:length(I)
		[C_, R, V] = weakClassify(feature, D{i}, I, i, feature.int, R);
		fprintf('V = %d, %d\tP = %d, %d\n', size(V,1), size(V,2), size(P{i}, 1), size(P{i},2));
		values = [values V(1:(size(V,1)*size(V,2)))];
		signs  = [signs P{i}(1:(size(P{i},1)*size(P{i},2)))];
	end

	size(values)
	size(signs)

	% Sort the data on the thresholds
	[values_, IDX] = sort(values);
	signs          = signs(IDX);
	l              = length(find(signs == 1));
	m              = length(signs) - l;

	iStar    = 1;
	best     = 0;
	positive = true;
	for i = 2:length(values)-1
		posLeft = length(find( signs(1:i) == 1 ));
		posRight= l - posLeft;
		negLeft = length(find( signs(1:i) == 0 ));
		negRight= m - negLeft;

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

	% Set the threshold
	feature.threshold = values(iStar);
	feature.positive  = positive;
end
