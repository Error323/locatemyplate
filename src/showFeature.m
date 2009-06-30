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
	global INTLABELS;
	% clf(fig);
	w = 100; h = 33;

	% set title of figure window
	title(['Feature to be aplied on ',INTLABELS{feature.int}]);

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
			c = 'b';
		else
			c = 'w';
		end

		% IMPORTANT, the feature is drawn (graph like) with its origin
		% in the left bottom. But in the other code the origin of
		% matrices are used, which are left top.

		% % vertical
		% if (feature.orientation == 1)
		% 	rectangle('Position', [x0, y0, x1-x0, y1-y0], 'FaceColor', c);
		% else % horizontal
		% 	rectangle('Position', [y0, x0, y1-y0,x1-x0], 'FaceColor', c);
		% end

		if (feature.orientation == 1)
			rx = x0;
			ry = y0;
			rw = x1-x0;
			rh = y1-y0;
		else % horizontal
			rx = y0;
			ry = x0;
			rw = y1-y0;
			rh = x1-x0;
		end
		% draw featureblock
		rectangle('Position', [rx,ry,rw,rh], 'FaceColor', c);
	end
	%fix for axis:
	axis([1,h,1,w]);
end
