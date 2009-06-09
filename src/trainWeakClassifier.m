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
	xsorted = data.x{I};
	ysorted = data.y{I};

	
end
