clear
close all
SEGMENTS = 2;
features = featureGeneration(SEGMENTS);

% for i=1:length(features)
% 	i		
% 	figure(i)
% 	showFeature(features{i},i)
% 	pause
% end
% 	pause
% 	pause

% set feature dimensions 
% TODO set to license plate dims!
% TODO use multiscale
% must be odd numbers to make the split go well
h = 3;
w = 5;

scale = 5
h = h * scale
w = w * scale

% if not odd, make odd
if mod(h,2)==0 h = h + 1;end;
if mod(w,2)==0 w = w + 1;end;

%for i=1:length(features)
f=1; %horizontal
f=2; %vertical
showFeature(features{f},f);
figure;

%img = [35     1     6    26    19    24; 3    32     7    21    23    25; 31     9     2    22    27    20; 8    28    33    17    10    15; 30     5    34    12    14    16; 4    36    29    13    18    11]
img = double(rgb2gray(imread('bril.jpeg')))/256;
imshow(img)
pause

% obtain dimensions
[imgH, imgW] = size(img);

R = {};

% loop through blocks
for b=1:length(features{f}.blocks)
	% obtain the feature block coords
	% disp('ori: ');
	y0 = features{f}.blocks{b}.coords(1);
	x0 = features{f}.blocks{b}.coords(2);
	y1 = features{f}.blocks{b}.coords(3);
	x1 = features{f}.blocks{b}.coords(4);

	% disp('scaled: ');
	% scale the feature block coords
	y0 = round(y0*h);
	x0 = round(x0*w);
	y1 = round(y1*h);
	x1 = round(x1*w);


	%disp('0,0 to 1,1:');
	% matlab matrices have a origin of (1,1), set (0,0) values to (1,1)
	y0 = max(1,y0);
	x0 = max(1,x0);
	y1 = max(1,y1);
	x1 = max(1,x1);

	% calculate and store feature block dimensions
	blockH = y1-y0+1;
	blockW = x1-x0+1;

	features{f}.blocks{b}.blockH = blockH;
	features{f}.blocks{b}.blockW = blockW;

	% store calculated coords
	features{f}.blocks{b}.coordsScaled = [y0, x0, y1, x1];

	


% img =
% 
%     35     1     6    26    19    24
%      3    32     7    21    23    25
%     31     9     2    22    27    20
%      8    28    33    17    10    15
%     30     5    34    12    14    16
%      4    36    29    13    18    11

	% if R is empty or if R entry is not computed yet
	if((size(R,1)==0 && size(R,2)==0) || (size(R{blockH,blockW},1)==0))
		disp(sprintf('Feature block of h=%d w=%d is now computed',blockH,blockW));
		% TODO: could be more optimal to do img(1:2,:) = [] (delete first 2 rows)
		X = img(1:imgH-blockH+1,1:imgW-blockW+1);
		Y = img(blockH:imgH, blockW:imgW);
		V = img(blockH:imgH, 1:imgW-blockW+1);
		W = img(1:imgH-blockH+1, blockW:imgW);

		% calculate total of integral and store the hash on de dimension of the feature block
		disp(sprintf('Storing R{%d}{%d}:',blockH,blockW));
		T = X+Y-V-W;
		R{blockH,blockW} = X+Y-V-W;
		R{blockH,blockW};
	else
		disp(sprintf('feature block of h=%d w=%d already computed',blockH,blockW));
	end
	%pause;
end	


% loop through blocks, starting from the second
for b=1:length(features{f}.blocks)
	% obtain feature block scaled coords
	y0 = features{f}.blocks{b}.coordsScaled(1);
	x0 = features{f}.blocks{b}.coordsScaled(2);
	y1 = features{f}.blocks{b}.coordsScaled(3);
	x1 = features{f}.blocks{b}.coordsScaled(4);

	orientation = features{f}.orientation;

	% obtain feature block scaled dimensions
	blockH = features{f}.blocks{b}.blockH;
	blockW = features{f}.blocks{b}.blockW;

	%disp('block:');
	%b
	%disp('range:');
	%x0:(imgW-(w-x0))
	% store matrix 
	if features{f}.blocks{b}.sig == 1
		R2{b} = R{blockH,blockW}(:,x0:(imgW-(w-x0)));
	else
		R2{b} = -R{blockH,blockW}(:,x0:(imgW-(w-x0)));
	end
	%R2{b}
	%pause

	% because the featureblocks have different origins
	% they need to get alligned at 1,1 origin
	% this is done by shifting it, (using x0:.. range)

	% if(orientation==1) % vertical feature
	% 	disp('vertical feature')
	% 	if features{f}.blocks{b}.sig == 1
	% 		Rtot = Rtot(:,1:size(Rtot,2)-x0+1) + R2{b}(:,x0:size(Rtot,2));
	% 	else
	% 		Rtot = Rtot(:,1:size(Rtot,2)-x0+1) - R2{b}(:,x0:size(Rtot,2));
	% 	end
	% else % horizontal feature
	% 	if features{f}.blocks{b}.sig == 1
	% 		Rtot = Rtot(1:size(Rtot,1)-y0+1, :) + R2{b}(y0:size(Rtot,1), :);
	% 	else
	% 		Rtot = Rtot(1:size(Rtot,1)-y0+1, :) - R2{b}(y0:size(Rtot,1), :);
	% 	end
	% end
	
end

Rtot = R2{1};
for b=2:length(R2)
		Rtot = Rtot + R2{b};
end


figure; imshow(Rtot);

% normalise image
% vMax = max(max(Rtot))
% vMin = min(min(Rtot))
% vRange = vMax - vMin
% RtotNorm = (Rtot - vMin)/vRange;
% figure;
% imshow(RtotNorm); 
