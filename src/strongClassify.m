%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% strongClassify(classifier, alphas, threshold, sample, dimensions)
%%
%% INPUTS:
%%  - classifier, the set of weak classifiers selected by vjBoost
%%  - alphas, their corresponding alphas
%%  - sample, the datapoint (image)
%%  - threshold, play with the confusion matrix
%%  - dimensions, the dimensions of the scanning window
%%
%% OUPUTS:
%%  - C, a matrix of the sample in {0,1}, true or false
%%  - V, the values of the weak classifiers summed
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [C, V] = strongClassify(classifier, alphas, threshold, sample, dimensions)
	% T         = length(classifier);
	% V         = zeros(size(sample) - dimensions);
	V         = 0;

	% license plate dimensions
	[h, w] = dimensions;

	scale = 1;
	h = h * scale;
	w = w * scale;

	% if not odd, make odd
	% (must be odd numbers to make the feature block split go well)
	if mod(h,2)==0 h = h + 1;end;
	if mod(w,2)==0 w = w + 1;end;

	features = classifier


	for f=1:length(features)
		img = I{features{f}.int};
		imshow(img);

		% horizontal feature
		if features{f}.orientation == 0
			% transpose
			if debug == true
				disp('horizontal feature transposing image..');
			end
			img = img';
		end

		% obtain dimensions
		[imgH, imgW] = size(img);

		R = {};

		% loop through blocks
		for b=1:length(features{f}.blocks)
			% obtain the feature block coords
			y0 = features{f}.blocks{b}.coords(1); x0 = features{f}.blocks{b}.coords(2); y1 = features{f}.blocks{b}.coords(3); x1 = features{f}.blocks{b}.coords(4);

			% scale the feature block coords
			y0 = round(y0*h); x0 = round(x0*w); y1 = round(y1*h); x1 = round(x1*w);


			% matlab matrices have a origin of (1,1), set (0,0) values to (1,1)
			y0 = max(1,y0); x0 = max(1,x0); y1 = max(1,y1); x1 = max(1,x1);

			% calculate and store feature block dimensions
			blockH = y1-y0+1; blockW = x1-x0+1;
			features{f}.blocks{b}.blockH = blockH; features{f}.blocks{b}.blockW = blockW;

			% store calculated coords
			features{f}.blocks{b}.coordsScaled = [y0, x0, y1, x1];

			% if R is empty or if R entry is not computed yet
			if((size(R,1)==0 && size(R,2)==0) || (size(R{blockH,blockW},1)==0))
				if debug
					disp(sprintf('Feature block of h=%d w=%d is now computed',blockH,blockW));
				end
				% TODO: could be more optimal to do img(1:2,:) = [] (delete first 2 rows)
				X = img(1:imgH-blockH+1,1:imgW-blockW+1);
				Y = img(blockH:imgH, blockW:imgW);
				V = img(blockH:imgH, 1:imgW-blockW+1);
				W = img(1:imgH-blockH+1, blockW:imgW);

				if debug
					X,Y,V,W
				end

				% calculate total of integral and store the hash on de dimension of the feature block
				if debug
					disp(sprintf('Storing R{%d}{%d}:',blockH,blockW));
				end
				T = X+Y-V-W;
				R{blockH,blockW} = X+Y-V-W;
				R{blockH,blockW};
			else
				if debug
					disp(sprintf('feature block of h=%d w=%d already computed',blockH,blockW));
				end
			end
			if debug
				pause;
			end
		end	


		% loop through blocks, starting from the second
		for b=1:length(features{f}.blocks)
			% obtain feature block scaled coords
			y0 = features{f}.blocks{b}.coordsScaled(1); x0 = features{f}.blocks{b}.coordsScaled(2); y1 = features{f}.blocks{b}.coordsScaled(3); x1 = features{f}.blocks{b}.coordsScaled(4);

			% obtain feature block scaled dimensions
			blockH = features{f}.blocks{b}.blockH; blockW = features{f}.blocks{b}.blockW;

			% if featureblock is positively signed
			if features{f}.blocks{b}.sig == 1
				R2{b} = R{blockH,blockW}(:,x0:(imgW-(w-x0)));
			else
				R2{b} = -R{blockH,blockW}(:,x0:(imgW-(w-x0)));
			end

			if debug
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

		if debug
			Rtot 
		end

		% horizontal feature
		if features{f}.orientation == 0
			% transpose
			Rtot = Rtot';
		end

		if debug
			Rtot 
			pause;
		end

		RtotBinary = (Rtot>features{f}.threshold);

		V = V + alphas(f) * RtotBinary;

	end

	C = ( V >= ( threshold * sum(alphas) ) );


	% % Create the summed value matrix
	% for t = 1:T
	% 	[C, V_] = weakClassify(classifier{t}, sample, dimensions);
	% 	V = V + alphas(t) * C;
	% end


	% % Create the binary matrix C
	% C = ( V >= ( threshold * sum(alphas) ) );
end
