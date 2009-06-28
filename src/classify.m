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
	global DEBUG;
	C = ones(size(sample{1}) - (dimensions-1));

	for i = 1:length(cascader)
		% Get the strong classifier
		S = cascader{i};

		[C_, V_] = strongClassify(S.classifier, dimensions, sample, {}, S.alphas, S.threshold);

		% Cascade
		C = C&C_;
		if (DEBUG)
			figure(i);
			imshow(C);
		end
	end
end
