%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% classify(cascader, sample, dimensions)
%%
%% INPUTS:
%%  - cascader, the cascading classifier
%%  - sample, the sample to classify on
%%  - dimensions, the window dimensions [h, w]
%%
%% OUPUTS:
%%  - C, a matrix of the sample in {0,1}, true or false
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [C, V] = classify(cascader, sample, dimensions)
	C = ones(size(sample{1}) - (dimensions-1));
	V = zeros(size(sample{1}) - (dimensions-1));

	for i = 1:length(cascader)
		% Get the strong classifier
		S = cascader{i};

		[Cprime, Vprime] = strongClassify(S.classifier, dimensions, sample, {}, S.alphas, S.threshold);

		% Cascade
		C = C & Cprime;
		V = V + Vprime;
	end
	V = V .* C;
end
