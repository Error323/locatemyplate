clear
close all

[I, P, N, D] = getData('../data/stills/plates-test.idx');
SEGMENTS = 5;
NR_INTEGRAL_IMG = 9;

%TODO BUG first 4 features are empty
features = featureGeneration(SEGMENTS);

for i=1:length(I)
	for j=2:NR_INTEGRAL_IMG
		R{i}{j} = {};


		% %TODO remove after betatesting!
		% I{i}{j} = imresize(I{i}{j},0.015);
		% size(I{i}{j});
		% D{i}(1) = 3;
		% D{i}(2) = 3;
	end
end


imageId = 2;

imshow(I{imageId}{1});
figure;

featureId = 6;
integralId = 2;
figure(2);
showFeature(features{featureId}, 2);
figure;
tic;
weakClassify(features{featureId}, D{imageId}, I, imageId, integralId, R);
toc;
