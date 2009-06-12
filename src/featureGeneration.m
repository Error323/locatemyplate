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

		vBlocks = {}; hBlocks = {};
		for j=2:length(binblocks)
			vBlock.coords = [0 binblocks(j-1) 1 binblocks(j)];
			vBlock.sig    = str2num(binsigns(j-1));
			vBlocks{j-1}  = vBlock;

			hBlock.coords = [binblocks(j-1) 0 binblocks(j) 1];
			hBlock.sig    = str2num(binsigns(j-1));
			hBlocks{j-1}  = hBlock;
		end

		vFeature.blocks    = vBlocks;
		vFeature.bin       = bin;
		vFeature.signs     = binsigns;

		hFeature.blocks    = hBlocks;
		hFeature.bin       = bin;
		hFeature.signs     = binsigns;

		unsignedFeatures{i*2}   = vFeature;
		unsignedFeatures{i*2-1} = hFeature;
	end

	for i = 0:1
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
