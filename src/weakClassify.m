%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% weakClassify(feature, dimensions, images, imageId, integralId, R)
%%
%% INPUTS:
%%  - feature, 
%%  -	dimensions, 1x2 matrix of height and width of license plate
%%  - images, all the (integral) images
%%  - imageId, image selector
%%  - integralId, integral image selector
%%  - R, the rapid hash matrix which stores for every image for every 
%% 		integral image the dimensions of a block of a feature and its belongig 
%% 		value for every position in the original image.
%%
%% OUPUTS:
%%  - C, matrix with {0,1}, true or false
%%  - R, updated rapid hash matrix
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [C, R] = weakClassify(feature, dimensions, images, imageId, integralId, R)
	DEBUGGING = true;
	DEBUGGING = false;

	% obtain dimensions
	h = dimensions(1);
	w = dimensions(2);

	% select proper integral image
	img = images{imageId}{integralId};

	scale = 1;
	h = h * scale;
	w = w * scale;

	% if not odd, make odd
	% (must be odd numbers to make the feature block split go well)
	if mod(h,2)==0 h = h + 1;end;
	if mod(w,2)==0 w = w + 1;end;

	% horizontal feature
	if feature.orientation == 0
		% transpose
		if DEBUGGING == true
			disp('horizontal feature transposing image..');
		end
		img = img';
	end

	% obtain dimensions
	[imgH, imgW] = size(img);

	% loop through blocks
	for b=1:length(feature.blocks)
		% obtain the feature block coords
		y0 = feature.blocks{b}.coords(1); x0 = feature.blocks{b}.coords(2); y1 = feature.blocks{b}.coords(3); x1 = feature.blocks{b}.coords(4);

		% TODO optimalization: calculate scaled coords once (at feature generation)

		% scale the feature block coords
		y0 = round(y0*h); x0 = round(x0*w); y1 = round(y1*h); x1 = round(x1*w);

		% matlab matrices have a origin of (1,1), set (0,0) values to (1,1)
		y0 = max(1,y0); x0 = max(1,x0); y1 = max(1,y1); x1 = max(1,x1);

		% calculate and store feature block dimensions
		blockH = y1-y0+1; blockW = x1-x0+1;
		feature.blocks{b}.blockH = blockH; feature.blocks{b}.blockW = blockW;

		% store calculated coords
		feature.blocks{b}.coordsScaled = [y0, x0, y1, x1];

		% if R entry is empty or if R entry is not computed yet
		hashString = strcat('h', int2str(blockH), 'w', int2str(blockW));
		
		% if featureblock is not calculated previously
		if( ~isfield(R{imageId}{integralId},hashString) )
			if DEBUGGING
				disp(sprintf('Feature block of h=%d w=%d is now computed',blockH,blockW));
			end
			% TODO: could be more optimal to do img(1:2,:) = [] (delete first 2 rows)
			X = img(1:imgH-blockH+1,1:imgW-blockW+1);
			Y = img(blockH:imgH, blockW:imgW);
			V = img(blockH:imgH, 1:imgW-blockW+1);
			W = img(1:imgH-blockH+1, blockW:imgW);

			if DEBUGGING
				X,Y,V,W
			end

			% calculate total of integral and store the hash on de dimensions of the feature block
			if DEBUGGING
				disp(sprintf('Storing R{%d}{%d}(h%dw%d):',imageId,integralId,blockH,blockW));
			end
			T = X+Y-V-W;
			R{imageId}{integralId}.(hashString) = X+Y-V-W;
			R{imageId}{integralId}.(hashString);
		else
			if DEBUGGING
				disp(sprintf('feature block of h=%d w=%d already computed',blockH,blockW));
			end
		end
		if DEBUGGING
			pause;
		end
	end	

	% loop through blocks
	for b=1:length(feature.blocks)
		% obtain feature block scaled coords
		y0 = feature.blocks{b}.coordsScaled(1); x0 = feature.blocks{b}.coordsScaled(2); y1 = feature.blocks{b}.coordsScaled(3); x1 = feature.blocks{b}.coordsScaled(4);

		% obtain feature block scaled dimensions
		blockH = feature.blocks{b}.blockH; blockW = feature.blocks{b}.blockW;

		hashString = strcat('h', int2str(blockH), 'w', int2str(blockW));
		% if featureblock is positively signed
		if feature.blocks{b}.sig == 1
			R2{b} = R{imageId}{integralId}.(hashString)(:,x0:(imgW-(w-x0)));
		else
			R2{b} = -R{imageId}{integralId}.(hashString)(:,x0:(imgW-(w-x0)));
		end

		if DEBUGGING
			b
			R2{b}
			pause
		end
		
	end

	% calculate sum off feature blocks
	Rtot = 0;
	for b=1:length(R2)
			Rtot = Rtot + R2{b};
	end

	if DEBUGGING
		Rtot 
	end

	% horizontal feature
	if feature.orientation == 0
		% transpose
		Rtot = Rtot';
	end

	if DEBUGGING
		Rtot 
		pause;
	end

	% return thresholded image
	C = (Rtot>feature.threshold);

	if DEBUGGING
		imshow(C);
	end
	%imshow(C);
end
