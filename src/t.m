clear
close all
globals

% Obtain test data
if (exist('../cache/test.mat', 'file'))
	disp('using cashed data');
	load('../cache/test.mat', 'data');
else
	disp('loading data');
	data = getData('../data/stills/plates-test.idx', 0.5);
	save('../cache/test.mat', 'data');
end

I = data.I;
P = data.P;
N = data.N;
D = data.D;

% disp('resizing images');
% tic;
% for i=1:length(I)
% 	for j=1:length(I{i})
% 		I{i}{j} = imresize(I{i}{j},0.42);
% 	end
% end
% toc;

SEGMENTS = 2;

%TODO BUG first 4 features are empty
features = featureGeneration(SEGMENTS);

for i=1:length(I)
	for j=2:INTEGRALS
		R{i}{j} = {};


		% %TODO remove after betatesting!
		% I{i}{j} = imresize(I{i}{j},0.015);
		% size(I{i}{j});
		% D{i}(1) = 3;
		% D{i}(2) = 3;
	end
end


imageId = 1;

% figure(3);
imshow(I{imageId}{1});
% 
% figure(1);
% figure(2);
% 
% for featureId=510:1700000
% 	integralId = 2;
% 	clf(2);
% 	showFeature(features{featureId}, 2);
% 	tic;
% 	weakClassify(features{featureId}, D{imageId}, I, imageId, integralId, R);
% 	pause(2);
% end

alphas = ones(1,length(features));
pause
disp('strongclassifying');
strongClassify({features{1},features{2}}, D{imageId}, I, alphas,1);
