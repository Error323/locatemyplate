clear
close all

% Obtain test data
if (exist('../cache/testI.mat', 'file'))
	disp('using cashed data');
	load('../cache/testI.mat', 'I');
	load('../cache/testP.mat', 'P');
	load('../cache/testN.mat', 'N');
	load('../cache/testD.mat', 'D');
else
	disp('loading data');
	[I, P, N, D] = getData('../data/stills/plates-test.idx');
	save('../cache/testI.mat', 'I');
	save('../cache/testP.mat', 'P');
	save('../cache/testN.mat', 'N');
	save('../cache/testD.mat', 'D');
end


SEGMENTS = 4;
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

figure;
imshow(I{imageId}{1});

figure(1);
figure(2);

pause;
for featureId=30:70
	integralId = 2;
	showFeature(features{featureId}, 2);
	tic;
	weakClassify(features{featureId}, D{imageId}, I, imageId, integralId, R);
	toc;
	pause(1);
end
