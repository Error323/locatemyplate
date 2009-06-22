%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% classify(cascader, sample, dimensions)
%%
%% INPUTS:
%%  - cascader, the cascading classifier
%%  - sample, the sample to classify on
%%  - dimensions, the window dimensions
%%
%% OUPUTS:
%%  - C, a matrix of the sample in {0,1}, true or false
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function C = classify(cascader, sample, dimensions)
	C = ones(size(sample) - dimensions);

	for i = 1:length(cascader)
		% Get the strong classifier
		S = cascader{i};

		[C_, V_] = strongClassify(S.classifier, S.alphas, S.threshold, sample, dimensions);

		% Cascade
		C = C&C_;
	end
end
