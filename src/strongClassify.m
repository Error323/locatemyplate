%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% strongClassify(features, alphas, threshold, sample, dimensions)
%%
%% INPUTS:
%%  - features, the set of weak classifiers selected by vjBoost
%%  - alphas, their corresponding alphas
%%  - sample, the datapoint (image)
%%  - dimensions, the dimensions of the scanning window
%%
%% OUPUTS:
%%  - C, a matrix of the sample in {0,1}, true or false
%%  - V, the values of the weak classifiers summed
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [C, V] = strongClassify(features, dimensions, Images, alphas, threshold) 
	globals

	% initalize hash matrix
	for i=1:length(Images)
		for j=2:INTEGRALS
			R{i}{j} = {};
		end
	end

	T         = length(features);
	%TODO initialise with zeros(..)
	imageId   = 1;
	%V         = zeros(size(Images{imageId}{1})-dimensions);
	V = 0;
	% size(Images{imageId}{1})
	% dimensions
	% disp('size  init V');
	% size(V)

	% Create the summed value matrix
	for t = 1:T
		integralId = features{t}.int
		[C, R] = weakClassify(features{t}, dimensions, Images, imageId, integralId, R);
		disp('size V');
		size(V)
		disp('size C');
		size(C)
		V = V + alphas(t) * C;
	end

	VMin = min(min(V));
	VMax = max(max(V));
	VRange = VMax-VMin;
	VNormalised = (V - VMin)/VRange;
	figure(1);
	imshow(V);

	% Create the binary matrix C
	C = ( V >= ( threshold * sum(alphas) ) );
end
