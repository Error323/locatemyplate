
img = imread('/home/fhuizing/studie/jaar5/project-2/data/stills/images/cars053.jpg');
imgGray = rgb2gray(img);
x = 239;
y = 203;
xD = 76;
yD = 26;


A = zeros(yD,xD)
for i = 1:yD
	for j = 1:xD
		A(i,j) = imgGray(i+y-1,j+x-1);
	end
end

A = A / 256;
figure;
imshow(A);
