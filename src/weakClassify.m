%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% weakClassify(feature, x, integrals)
%%
%% INPUTS:
%%  - feature, the box feature
%%  - x, the datapoint (image)
%%  - integrals, the integrals belonging to datapoint x
%%
%% OUPUTS:
%%  - c in {0,1}, true or false
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function c = weakClassify(feature, x, integrals)
	[h, w] = size(x.image);
	intImg = integrals{feature.int};

	pos = 0; neg = 0;
	for i = 1:size(feature.blocks,2)
		% Get the block coordinates
		y0 = feature.blocks{i}.coords(1);
		x0 = feature.blocks{i}.coords(2);
		y1 = feature.blocks{i}.coords(3);
		x1 = feature.blocks{i}.coords(4);

		% Adjust the block to the x datapoint size
		y0 = max(floor(y0*h), 1);
		x0 = max(floor(x0*w), 1);
		y1 = max(floor(y1*h), 1);
		x1 = max(floor(x1*w), 1);

		s  = intImg(y0,x0) + intImg(y1,x1) - (intImg(y1,x0) + intImg(y0,x1));

		if feature.blocks{i}.sig == 1
			pos = pos + s;
		else
			neg = neg + s;
		end
	end

	if ((pos - neg) >= feature.threshold)
		c = 1;
	else
		c = 0;
	end
end
