%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% trainWeakClassifier(feature, data, m, l)
%%
%% INPUTS:
%%  - feature, the current feature being trained
%%  - data, the dataset holding + and - samples
%%  - m, number of negative samples
%%  - l, number of positive samples
%%
%% OUPUTS:
%%  - sets the threshold on a feature
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function trainWeakClassifier(feature, data, m, l)
	N = m + l;

	% Calculate the threshold for all datapoints using this feature
	T = zeros(1, N);
	for i = 1:N
		[c_, v] = weakClassify(feature, data.x{i}, data.imgInt{i});
		T(i)    = v;
	end

	% Sort the data on the thresholds
	[T_, I] = sort(T);
	ysorted = data.y(I);

	iStar    = 1;
	best     = 0;
	positive = 0;
	for i = 2:N-1
		posLeft = size(find( ysorted(1:i)   == 1 ), 2);
		posRight= l - posLeft;
		negLeft = size(find( ysorted(1:i)   == 0 ), 2);
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
	feature.threshold = T(iStar);
	feature.positive  = positive;
end
