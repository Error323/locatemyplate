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
	% img = imread('elle.jpg');
	% img = imresize(img,0.5);
	% imshow(img);
	global DEBUG INTEGRALS train;

	% get data 
	integralImgs  = train.I{1};
	dimensions = train.D{1};

	for j=1:length(INTEGRALS) %skip ori image
		Ri{INTEGRALS(j)} = {};
	end

	close all
	figure(1);
	maximize(1);
	
	nrLayers   = size(cascader.cascader,2);

	nrFeaturesTotal  = 0;
	for layer=1:nrLayers
		nrFeaturesTotal = nrFeaturesTotal + size(cascader.cascader{1,layer}.classifier,2);
	end

	subplotWidth = nrFeaturesTotal
	subplotHeight = 3;

	i = 1;
	for layer=1:nrLayers
		nrFeatures = size(cascader.cascader{1,layer}.classifier,2);
		alphas = cascader.cascader{1,layer}.alphas;

		for f=1:nrFeatures

			feature = cascader.cascader{1,layer}.classifier{1,f};
			subplot(subplotHeight,subplotWidth, i); showFeature(feature,i)

			integralId 	= feature.int;
			img 				= integralImgs{integralId};
			Rij 			  = Ri{integralId};
			[C, RijClassified_, V] = weakClassify(feature, dimensions, img, Rij);
			%V      = V + alphas(f) * C;
			%V      = alphas(f) * C;

			% normalise img
			VMin = min(min(V));
			VMax = max(max(V));
			VRange = VMax-VMin;
			VNormalised = (V - VMin)/VRange;
			%plot img
			magnification = 30;
			subplot(subplotHeight,subplotWidth, i+subplotWidth); imshow(VNormalised);
			subplot(subplotHeight,subplotWidth, i+2*subplotWidth); imshow(C);

			i = i + 1;
		end
	end
	%subplot(subplotHeight,subplotWidth,i)
end
