clear;
close all;

path = '../data/stills/images/';
file=dir([path,'*.jpg']);
for q=1:size(file,1)
	filename = [path,file(q).name]
	img = imread(filename);
	imgGray = rgb2gray(img);
	[h,w] = size(imgGray);

	x = 239;
	y = 203;
	xD = 76;
	yD = 26;


	A = zeros(yD,xD);
	for i = 1:yD
		for j = 1:xD
			A(i,j) = imgGray(i+y-1,j+x-1);
		end
	end

	A = A / 256;

	% define x and y derivative filters
	Fxd = [-1 0 1;-1 0 1;-1 0 1];
	Fyd = Fxd';

	%figure(1);imshow(imgGray);

	Axd = imfilter(imgGray,Fxd);
	%figure(10);imshow(Axd);
	imshow(img)

	integralImg = cumsum(cumsum(double(Axd),2));

	% define custum feature
	f.negY = [0,1/5,  4/5,1];
	f.negX = [0,1,    0,1];
	f.posY = [1/5,4/5];
	f.posX = [0,1];

	% scale by license plate size
	f.negY = f.negY * yD;
	f.negX = f.negX * xD;
	f.posY = f.posY * yD;
	f.posX = f.posX * xD;

	% optional TODO: addition of subpixel approx by interpolation instead of just rounding
	f.negY = round(f.negY)+1;
	f.negX = round(f.negX)+1;
	f.posY = round(f.posY)+1;
	f.posX = round(f.posX)+1;


	xOffset = 0;
	yOffset = 0;
	%xOffset = x;
	%yOffset = y;

	maxR = -inf;
	stepSize = 2;

	yStart = 203; 
	xStart = 219;

	% y = 203;
	% x = 239;
	for yOffset=yStart:stepSize:(h-yD)
		for xOffset=xStart:stepSize:(w-xD)
			
			sumAreaNeg = 0;
			for j = 1:2:size(f.negY,2)-1
				y0 = f.negY(j)+yOffset;
				x0 = f.negX(j)+xOffset;
				y1 = f.negY(j+1)+yOffset;
				x1 = f.negX(j+1)+xOffset;
				sumAreaNeg = sumAreaNeg + integralImg(y0,x0)+integralImg(y1,x1)-(integralImg(y1,x0)+integralImg(y0,x1));

				% A = zeros(size(integralImg));
				% A(y0,x0) = 1
				% A(y1,x1) = 1
				% A(y1,x0) = -1
				% A(y0,x1) = -1
				% sumAreaNeg = sum(sum(A*integralImg));
				
			end

			sumAreaPos = 0;
			for j = 1:2:size(f.posY,2)-1
				y0 = f.posY(j)+yOffset;
				x0 = f.posX(j)+xOffset;
				y1 = f.posY(j+1)+yOffset;
				x1 = f.posX(j+1)+xOffset;
				sumAreaPos = sumAreaPos + integralImg(y0,x0)+integralImg(y1,x1)-(integralImg(y1,x0)+integralImg(y0,x1));
			end

			r = sumAreaPos-sumAreaNeg;
			if (r>maxR)
				maxR = r;
				coords = [yOffset,xOffset];
			end

			%rectangle('Position',[xOffset, yOffset, xD, yD]);
			%input('key');

		end
	end
		

	coords

	rectangle('Position',[coords(2), coords(1), xD, yD], 'FaceColor','r');
	pause(2)
end
