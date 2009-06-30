%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% showCascader(cascader)
%%
%% INPUTS:
%%  - cascader, the cascader which contains the layers with features
%%  - data, 
%%  - imageId, use 0 to loop all
%%
%% OUPUTS:
%%	- nothing
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function showCascader(cascader, data, imageId)
	% NOTE first run globals.m to get data
	global DEBUG INTEGRALS;
	I = data.I;
	D = data.D;
	
	% detemine image range
	if (imageId > 0)
		fromImage=imageId;
		tillImage=imageId;
	else
		%fromImage=1;
		fromImage=8;
		tillImage=length(data.I);
	end

	%start new figure
	close all
	figure(1);

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

		nrLayers         = length(cascader);

		% feature, V, C weak, C strong = #4
		subplotHeight = 3;

		% determine layer range
		fromLayer=1;
		tillLayer=nrLayers;
		subplotWidth = nrLayers;

		% plot car in grayscale 
		% subplot(subplotHeight,subplotWidth, 1); imshow(I{imageId}{1}); title('Original image');

		% loop through cascader/layers/strong classifiers
		for layer=fromLayer:tillLayer
			layer
			% retrieve current strong classifier
			S 					= cascader{layer};




			[SCprime, SVprime] = strongClassify(S.classifier, D{imageId}, I{imageId}, {}, S.alphas, S.threshold);
			% and with C from prev layer
			SC = SC & SCprime;
			%SV = SV + SVprime;
			SV = SVprime;

			% filter only pos examples
			SV = SV .* SC;

			SVnormalised = normaliseImg(SV);

			%subplot(subplotHeight,subplotWidth, f+(4*subplotWidth)); imshow(C);
			subplot(subplotHeight,subplotWidth, layer+(0*subplotWidth)); imshow(SVprime); title(sprintf('Value layer %d', layer))
			subplot(subplotHeight,subplotWidth, layer+(1*subplotWidth)); imshow(SCprime); title(sprintf('Thresholded value layer %d', layer))
			subplot(subplotHeight,subplotWidth, layer+(2*subplotWidth)); imshow(SVnormalised); title(sprintf('Layer(s) 1..%d combined', layer))

		end
	pause;
	end
end
