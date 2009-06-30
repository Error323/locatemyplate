%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% showCascader(cascader)
%%
%% INPUTS:
%%  - cascader, the cascader which contains the layers with features
%%
%% OUPUTS:
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function showCascader(cascader, data)
	% NOTE first run globals.m to get data
	global DEBUG INTEGRALS;
	I = data.I;
	D = data.D;
	
	%imageId = 8;
	%for imageId=9:200
	for imageId=14:14
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
		subplotHeight = 5;

		% loop through cascader/layers/strong classifiers
		%for layer=1:nrLayers
		for layer=2:2
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
			subplot(subplotHeight,subplotWidth, 1); imshow(I{imageId}{1});


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
			

			[SCprime, SVprime] = strongClassify(S.classifier, D{imageId}, I{imageId}, {}, S.alphas, S.threshold);
			% and with C from prev layer
			SC = SC & SCprime;
			SV = SV + SVprime;

			% filter only pos examples
			SV = SV .* SC;

			Vnormalised = normaliseImg(SV);

			%subplot(subplotHeight,subplotWidth, f+(4*subplotWidth)); imshow(C);
			subplot(subplotHeight,subplotWidth, f+(4*subplotWidth)); imshow(Vnormalised);
			pause;

		end
		%subplot(subplotHeight,subplotWidth,i)
	pause;
	end
end
