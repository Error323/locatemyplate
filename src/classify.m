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
	global DEBUG;
	C = ones(size(sample{1}) - (dimensions-1));
	V = zeros(size(sample{1}) - (dimensions-1));

	for i = 1:length(cascader)
		% Get the strong classifier
		S = cascader{i};

		[Cprime, Vprime] = strongClassify(S.classifier, dimensions, sample, {}, S.alphas, S.threshold);
		% Cascade
		figure;
		imshow(C);
		pause;
		C = C & Cprime;

		V = V + Vprime;

		if DEBUG 
			figure(1);
			imshow(C);
			figure(2);
			% normalise img
			Vnormalised = normaliseImg(V);
			imshow(Vnormalised);
			pause;
		end
	end
end
