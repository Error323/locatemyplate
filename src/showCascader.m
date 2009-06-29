%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% showCascader(cascader)
%%
%% INPUTS:
%%  - cascader, the cascader which contains the layers with features
%%
%% OUPUTS:
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function showCascader(cascader)
	% NOTE first run globals.m to get data
	global DEBUG INTEGRALS train;
	imageId = 3;

	I = train.I;
	D = train.D;
	integralImgs  = I{imageId};
	
	% initialize integral images
	for j=1:length(INTEGRALS) %skip ori image
		Ri{INTEGRALS(j)} = {};
	end

	% initialise strong classifier
	C = ones(size(I{imageId}) - (D{imageId}-1));

	close all;
	
	nrLayers         = size(cascader.cascader,2);

	% feature, V, C weak, C strong = #4
	subplotHeight = 5;

	% loop through cascader/layers/strong classifiers
	for layer=1:nrLayers
		% retrieve current strong classifier
		S 					= cascader.cascader{layer};

		% calculate feature total for subplot width
		nrFeatures 	= size(S.classifier,2);
		subplotWidth = nrFeatures;

		%start new figure
		figure(layer);
		maximize(layer);

		% plot car in grayscale 
		%subplot(subplotHeight,subplotWidth, 1); imshow(I{imageId}{1});
		subplot(subplotHeight, subplotWidth, 1); imshow(I{imageId}{1}*256);

		% loop through features/weak classifiers
		for f=1:nrFeatures
			% retrieve feature
			feature = S.classifier{f};
			% display feature
			subplot(subplotHeight, subplotWidth, f+(1*subplotWidth)); showFeature(feature,layer)

			integralId 	= feature.int;
			img 				= integralImgs{integralId};
			Rij 			  = Ri{integralId};
			[C, RijClassified_, V] = weakClassify(feature, D{imageId}, img, Rij);
			%V      = V + alphas(f) * C;
			%V      = alphas(f) * C;

			VNormalised = normaliseImg(V);
			%plot img
			subplot(subplotHeight,subplotWidth, f+(2*subplotWidth)); imshow(VNormalised);
			subplot(subplotHeight,subplotWidth, f+(3*subplotWidth)); imshow(C);
		end
		

		[Cprime, Vprime_] = strongClassify(S.classifier, D{imageId}, I{imageId}, {}, S.alphas, S.threshold);
		% and with C from prev layer
		C = C & Cprime;

		subplot(subplotHeight,subplotWidth, f+(4*subplotWidth)); imshow(C);
		pause;

	end
	%subplot(subplotHeight,subplotWidth,i)
end

function VNormalised  = normaliseImg(V)
	% normalise img
	VMin = min(min(V));
	VMax = max(max(V));
	VRange = VMax-VMin;
	VNormalised = (V - VMin)/VRange;
end
