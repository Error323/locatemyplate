%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% detector(img, w, h)
%%
%% INPUTS:
%%  - img, the rgb image to detect the license plate(s) on
%%  - w, the search window width
%%  - h, the search window height
%%
%% OUPUTS:
%%  - locations, a list holding plate locations (x,y pairs: [x0, y0,...]) 
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function locations = detector(C, alphas, img, w, h)
	locations = [];

	[H, W, K] = size(img);

	imgGray = double(rgb2gray(img))/256;
	for i = 1:1:H-h
		for j = 1:1:W-w
			sample = imgGray(i:i+h, j:j+w,:);
			[c, v_] = strongClassify(C, alphas, sample);
			if (c == 1)
				locations = [locations i j];
			end
		end
	end
	figure(1);
	imshow(img);
	for i = 2:2:length(locations)
		rectangle('Position', [locations(i), locations(i-1), w, h], 'EdgeColor', 'r');
	end
end
