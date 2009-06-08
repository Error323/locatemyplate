%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% trainingData(file)
%%
%% INPUTS:
%%  - file, the index file
%%
%% OUPUTS:
%%  - data, the trainings data
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function data = trainingData(file)
	text        = textread(file, '%s', 'whitespace', '\n\t ');
	N           = size(text, 1);
	M           = 3;

	data.x      = {}; % The sample window
	data.intImg = {}; % The integral images
	data.y      = []; % The sample being positive or negative

	dataidx = 1;
	for i = 1:6:N % Assuming 1 license plate per sample

		img     = imread(text{i});
		imgGray = double(rgb2gray(img))/256;

		[ySize, xSize] = size(imgGray);

		% Get sample coords
		c   = str2num(text{i+1});
		x   = str2num(text{i+2});
		y   = str2num(text{i+3});
		w   = str2num(text{i+4});
		h   = str2num(text{i+5});

		% Get our sample
		possample = zeros(h, w);
		for j = 1:h
			for k = 1:w
				possample(j,k) = imgGray(j+y-1, k+x-1);
			end
		end

		% Get the integral images
		data.intImg{dataidx} = getIntegrals(possample);

		% Set the sample
		data.x{dataidx} = possample;

		% Set to positive example
		data.y(dataidx) = 1;

		% Get some negative samples from this image
		dataidx = dataidx + 1;
		j = 0;
		while (j < M)
			h2     = round(h/2);
			w2     = round(w/2);
			yloc   = randi(ySize-h);
			xloc   = randi(xSize-w);
			ybound = (yloc+h < y || yloc-h > y);
			xbound = (xloc+w < x || xloc-w > x);

			if (ybound && xbound)

				negsample = zeros(h, w);
				for k = 1:h
					for l = 1:w
						negsample(k,l) = imgGray(k+yloc-1, l+xloc-1);
					end
				end

				% Get the integral images
				data.intImg{dataidx} = getIntegrals(negsample);

				% Set the sample
				data.x{dataidx}      = negsample;

				% Set to negative sample
				data.y(dataidx)      = 0;

				dataidx              = dataidx + 1;
				j                    = j + 1;
			end
		end
	end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% integrals(sample)
%%
%% INPUTS:
%%  - sample, the image sample
%%
%% OUPUTS:
%%  - integrals, the integral images
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function integrals = getIntegrals(sample)
	integrals = {};

	% Get the abs x-derivative
	Fdx = [-1 0 1;-1 0 1;-1 0 1];
	dxAbs = abs(imfilter(sample, Fdx));
	integrals.dxabs = cumsum(cumsum(dxAbs,2));

	% Get the abs y-derivative
	Fdy = Fdx';
	dyAbs = abs(imfilter(sample, Fdy));
	integrals.dyabs = cumsum(cumsum(dyAbs,2));
end
