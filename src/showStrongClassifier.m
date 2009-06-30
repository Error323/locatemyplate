%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% showStrongClassifier(cascader, data, imageId, layers)
%%
%% INPUTS:
%%  - cascader, the cascader which contains the layers with features
%%  - data, 
%%  - imageId, use 0 to loop all
%%  - layer, use 0 to loop all
%%
%% OUPUTS:
%%	- nothing
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function showStrongClassifier(cascader, data, imageId, layers)
	% NOTE first run globals.m to get data
	global DEBUG INTEGRALS;
	I = data.I;
	D = data.D;
	
	% detemine image range
	if (imageId > 0)
		fromImage=imageId;
		tillImage=imageId;
	else
		fromImage=1;
		tillImage=length(data.I);
	end

	for imageId=fromImage:tillImage
		imageId
		integralImgs  = I{imageId};
		
		% initialize integral images
		for j=1:length(INTEGRALS) %skip ori image
			Ri{INTEGRALS(j)} = {};
		end

		% initialise strong classifier
		C = ones(size(I{imageId}{1}) - (D{imageId}-1));
		SC = ones(size(I{imageId}{1}) - (D{imageId}-1));
		V = zeros(size(I{imageId}{1}) - (D{imageId}-1));
		SV = zeros(size(I{imageId}{1}) - (D{imageId}-1));

		close all;
		
		nrLayers         = length(cascader);

		% feature, V, C weak, C strong = #4
		subplotHeight = 4;

		% determine layer range
		if (layers > 0)
			fromLayer=layers;
			tillLayer=layers;
		else
			fromLayer=1;
			tillLayer=nrLayers;
		end

		% loop through cascader/layers/strong classifiers
		for layer=fromLayer:tillLayer
			layer
			% retrieve current strong classifier
			S 					= cascader{layer};

			% calculate feature total for subplot width
			nrFeatures 	= size(S.classifier,2);
			subplotWidth = nrFeatures;

			%start new figure
			figure(layer);
			% remove padding

			maximize(layer);

			% plot car in grayscale 
			subplot(subplotHeight,subplotWidth, 1); imshow(I{imageId}{1}); title('Original image');


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
				subplot(subplotHeight,subplotWidth, f+(2*subplotWidth)); imshow(VNormalised); title('Feature applied');
				subplot(subplotHeight,subplotWidth, f+(3*subplotWidth)); imshow(C); title('Threshold applied');
			end
			

			[SCprime, SVprime] = strongClassify(S.classifier, D{imageId}, I{imageId}, {}, S.alphas, S.threshold);
			% and with C from prev layer
			SC = SC & SCprime;
			%SV = SV + SVprime;
			SV = SVprime;

			% filter only pos examples
			SV = SV .* SC;

			Vnormalised = normaliseImg(SV);

			%subplot(subplotHeight,subplotWidth, f+(4*subplotWidth)); imshow(C);
			if subplotWidth>1
				subplot(subplotHeight,subplotWidth, 2); imshow(Vnormalised); title('Result of strong classifier')
			end
			pause;

		end
		%subplot(subplotHeight,subplotWidth,i)
	pause;
	end
end
