%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% showFeature(feature, fig)
%%
%% INPUTS:
%%  - feature, the feature to show
%%  - fig, the figure on which to plot it
%%
%% OUPUTS:
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function showFeature(feature, fig)
	figure(fig);
	w = 100; h = 33;

	colors = ['r', 'g', 'b', 'w'];
	c = colors(feature.int);
	disp(sprintf('feature int = %d, color = %s', feature.int, c));

	for i = 1:length(feature.blocks)
		y0 = feature.blocks{i}.coords(1);
		x0 = feature.blocks{i}.coords(2);
		y1 = feature.blocks{i}.coords(3);
		x1 = feature.blocks{i}.coords(4);

		y0 = max(floor(y0*h), 0);
		x0 = max(floor(x0*w), 0);
		y1 = max(floor(y1*h), 0);
		x1 = max(floor(x1*w), 0);

		if (feature.blocks{i}.sig == 1)
			rectangle('Position', [x0, y0, x1-x0, y1-y0], 'FaceColor', c);
		else
			rectangle('Position', [x0, y0, x1-x0, y1-y0], 'FaceColor', 'w');
		end
	end
end
