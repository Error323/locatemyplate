%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% strongClassify(features, alphas, threshold, sample, dimensions)
%%
%% INPUTS:
%%  - features, the set of weak classifiers selected by vjBoost
%%  - dimensions, the dimensions of the scanning window
%%  - integralImgs, all integral images of one picture
%%  - alphas
%%  - threshold
%%
%% OUPUTS:
%%  - C, a matrix of the sample in {0,1}, true or false
%%  - V, the values of the weak classifiers summed
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [C, V] = strongClassify(features, dimensions, integralImgs, Ri, alphas, threshold) 
	global DEBUG INTEGRALS;

	for j=1:length(INTEGRALS) %skip ori image
		Ri{INTEGRALS(j)} = {};
	end

	%TODO initialise with zeros(..)
	V = 0;

	% Create the summed value matrix
	for t = 1:length(features);
		feature 		= features{t};
		integralId 	= features{t}.int;
		img 				= integralImgs{integralId};
		Rij 			  = Ri{integralId};

		%showFeature(feature, 2);
		[C, RijClassified, V] = weakClassify(feature, dimensions, img, Rij);
		Ri{integralId} = RijClassified;
		V      = V + alphas(t) * C;
	end

	% print normalized probability image
	if DEBUG
		VMin = min(min(V));
		VMax = max(max(V));
		VRange = VMax-VMin;
		VNormalised = (V - VMin)/VRange;
		%figure(1);
		figure;
		imshow(V);
	end

	% Create the binary matrix C where 1 indicates we founde a license plate
	% on that position
	C = ( V >= ( threshold * sum(alphas) ) );
end
