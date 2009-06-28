%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% weakClassify(feature, dimensions, Images, imageId, integralId, Rij)
%%
%% INPUTS:
%%  - feature, 
%%  -	dimensions, 1x2 matrix of height and width of license plate
%%  - img, the integral image (prev selected by feature.int) of a picture
%%  - Rij, the rapid hash matrix which stores for every image for every 
%% 		integral image the dimensions of a block of a feature and its belongig 
%% 		value for every position in the original image.
%%
%% OUPUTS:
%%  - C, matrix with {0,1}, true or false
%%  - Rij, updated rapid hash matrix
%%  - V, the image values after applying the feature
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [C, Rij, V] = weakClassify(feature, dimensions, img, Rij)
	global DEBUG 

	% obtain dimensions
	if feature.orientation == 0 % horizontal feature
		% flip dimensions
		h = dimensions(2);
		w = dimensions(1);
	else
		h = dimensions(1);
		w = dimensions(2);
	end

	scale = 1;
	h = h * scale;
	w = w * scale;

	% horizontal feature
	if feature.orientation == 0
		% transpose
		img = img';
	end

	% obtain dimensions
	[imgH, imgW] = size(img);

	% Compute blocks on image
	for b=1:length(feature.blocks)
		% obtain the feature block coords
		y0 = feature.blocks{b}.coords(1); y1 = feature.blocks{b}.coords(3);
		x0 = feature.blocks{b}.coords(2); x1 = feature.blocks{b}.coords(4);

		% TODO optimalization: calculate scaled coords once (at feature generation)

		% scale the feature block coords
		y0 = round(y0*h); y1 = round(y1*h);
		x0 = round(x0*w); x1 = round(x1*w);

		% matlab matrices have a origin of (1,1), set (0,0) values to (1,1)
		y0 = max(1,y0); x0 = max(1,x0); y1 = max(1,y1); x1 = max(1,x1);

		% calculate and store feature block dimensions
		blockH = y1-y0+1; blockW = x1-x0+1;
		feature.blocks{b}.blockH = blockH; 
		feature.blocks{b}.blockW = blockW;

		% store calculated coords
		feature.blocks{b}.coordsScaled = [y0, x0, y1, x1];

		% if Rij entry is empty or if Rij entry is not computed yet
		hashString = sprintf('h%dw%d', blockH, blockW);
		
		% if featureblock is not calculated previously
		if( ~isfield(Rij,hashString) )
			% TODO: could be more optimal to do img(1:2,:) = [] (delete first 2 rows)

			% explanation of the +1
			% when imgW differs 2 from blockW: the block could be on 2+1 positions
			% upper left position and 1 pos hifted to the right and 2 pos shifted to the right
			%      --  = 2
			% [   ]--
			% -[   ]-
			% --[   ]
			X = img(1:imgH-blockH+1,1:imgW-blockW+1);
			Y = img(blockH:imgH, blockW:imgW);
			V = img(blockH:imgH, 1:imgW-blockW+1);
			W = img(1:imgH-blockH+1, blockW:imgW);

			Rij.(hashString) = X+Y-V-W;
		end

		size(Rij.(hashString)(:,x0:(imgW-(w-x0))));
		% if featureblock is positively signed
		if feature.blocks{b}.sig == 1
			R2{b} = Rij.(hashString)(:,x0:(imgW-(w-x0)));
		else
			R2{b} = -Rij.(hashString)(:,x0:(imgW-(w-x0)));
		end

	end	

	% calculate sum off feature blocks
	V = 0;
	for b=1:length(R2)
		V = V + R2{b};
	end

	% horizontal feature
	if feature.orientation == 0
		% transpose
		V = V';
	end

	% this should help scaling issues
	V = V ./ (h*w);

	% return thresholded image
	if (feature.positive)
		C = (feature.threshold >= V);
	else
		C = (feature.threshold < V);
	end

	if DEBUG
		VMin = min(min(V));
		VMax = max(max(V));
		VRange = VMax-VMin;
		VNormalised = (V - VMin)/VRange;
		figure(3);
		imshow(VNormalised);
	end
end
