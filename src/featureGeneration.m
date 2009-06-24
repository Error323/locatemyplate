%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% featureGeneration(segments)
%%
%% INPUTS:
%%  - segments, number of segments of the (e.g. feature for 0110 this is 4)
%%
%% OUPUTS:
%%  - a list of generated features
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function features = featureGeneration(segments)
	NR_INTEGRAL_IMG = 9;
	debug = false;
	unsignedFeatures = {};
	powerset = 2^segments;

	for i = 1:(powerset-2)/2
		bin = dec2bin(i, segments);

		binblocks = [0];
		binsigns  = [bin(1)];
		for j=2:length(bin)
			if (bin(j) ~= bin(j-1))
				binblocks = [binblocks j-1];
				binsigns  = [binsigns bin(j)];
			end
		end
		binblocks = [binblocks segments];
		binblocks = binblocks*(1/segments);

		blocks = {}; 
		for j=2:length(binblocks)
			block.coords = [0 binblocks(j-1) 1 binblocks(j)];
			block.sig    = str2num(binsigns(j-1));
			blocks{j-1}  = block;
		end

		vFeature.blocks    		= blocks;
		vFeature.bin       		= bin;
		vFeature.signs     		= binsigns;
		vFeature.orientation 	= 1;

		hFeature.blocks    		= blocks;
		hFeature.bin       		= bin;
		hFeature.signs     		= binsigns;
		hFeature.orientation 	= 0;

		unsignedFeatures{i*2}   = vFeature;
		unsignedFeatures{i*2-1} = hFeature;
	end

	% for every integral image, (dx, dy, var dx, etc)
	for i = 2:NR_INTEGRAL_IMG % i = 1 is original gray image
		for j = 1:length(unsignedFeatures)
			feature           = unsignedFeatures{j};
			feature.int       = i+1;
			feature.positive  = 0;
			feature.threshold = 0;

			features{i*length(unsignedFeatures)+j} = feature;
			if (debug && i == 1)
				showFeature(feature, 1);
				pause;
			end
		end
	end
	if (debug) close; end
end
