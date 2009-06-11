%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% featureGeneration(nrSegments)
%%
%% INPUTS:
%%  - nrSegments, number of segments of the (e.g. feature for 0110 this is 4)
%%
%% OUPUTS:
%%  - a list of generated features
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function features = featureGeneration(nrSegments) 
	% initialize features
	features = {};

	% counting the decimal value of 1111... (of length nrSegments)
	maxDecimal = 0;
	for i = 0:nrSegments-1
		maxDecimal = maxDecimal + 2^i;
	end

	% generating (maxDecimal-1)/2) features
	% because we only need to generate half of them 
	for i = 0:((maxDecimal-1)/2)
		binFeature = [];

		% convert to decimal
		s = dec2bin(i);

		% loop backwards through feature
		for j=length(s):-1:1
			% offset is needed to make a 1 a 00000..01
			% storing the value with the offset everthing before offset becomes 0
			offset = nrSegments-length(s);
			index = j+offset;
			binFeature(index) = str2num(s(j));
		end

		binFeatureBlocks = [];
		binFeatureSign = [];
		% loop through binFeature
		for k=2:length(binFeature)
			% flip detection
			if(binFeature(k-1) ~= binFeature(k))
				binFeatureBlocks = [binFeatureBlocks k-1];
				binFeatureSign = [binFeatureSign binFeature(k-1)];
			end
		end
		% add last block and sign
		binFeatureBlocks = [binFeatureBlocks length(binFeature)];
		binFeatureSign = [binFeatureSign binFeature(length(binFeature))];

		% add first block
		binFeatureBlocks = [0 binFeatureBlocks];
		
		% normalise to nrSegments 
		fraction = 1/nrSegments;
		binFeatureBlocks = binFeatureBlocks * fraction;

		blocks = {};
		% loop trough coordinate pairs and build feature blocks
		for m=2:length(binFeatureBlocks)
			block.coords = [0 binFeatureBlocks(m-1) 1 binFeatureBlocks(m)];
			block.sig = binFeatureSign(m-1);
			feature.blocks{m-1} = block;
			% todo horizontal
		end	

		% store feature in list
		features{i+1} = feature;
	end

	% % print features
	% disp('Printing generated features')
	% for e = 1:length(features)
	% 	disp('e')
	% 	e
	% 	for f = 1:length(features{e}.blocks)
	% 		disp('f')
	% 		f
	% 		features{e}.blocks{f}
	% 		pause
	% 	end
	% end
end
