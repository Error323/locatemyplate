clear
close all
globals

% Obtain test data
if (exist('../cache/test.mat', 'file'))
	disp('using cached data');
	load('../cache/test.mat', 'data');
else
	disp('loading data');
	data = getData('../data/stills/plates-test.idx', 0.5);
	save('../cache/test.mat', 'data');
end

I = data.I; P = data.P; N = data.N; D = data.D;

disp('generating features');
features = featureGeneration(SEGMENTS);
disp('done');

% initalize rapid hash matrix, 
for i=1:length(I)
		R{i} = {};
end

imageId = 1;

%figure(3);
%imshow(I{imageId},{1},);


% figure(1);
% figure(2);
% 
% for featureId=1:length(features)
% 	featureId
% 	clf(2);
% 	tic;
% 	feature 		= features{featureId},;
% 	integralId 	= features{featureId},.int;
% 	dimensions  = D{imageId},;
% 	img 				= I{imageId},{integralId},;
% 	Rtmp1				= R{imageId},{integralId},;
% 
% 	showFeature(feature, 2);
% 	[C, Rtmp2, V] = weakClassify(feature, dimensions, img, Rtmp1);
% 	R{imageId},{integralId}, = Rtmp2;
% 	toc;
% 	pause;
% end

% % training
% tic;
% for i=1:length(features)
% 	features{i}, = trainWeakClassifier(features{i},, data);
% 	fprintf('training %0.2f%% complete\n',(i/length(features))*100);
% end
% disp('training done press key to continue this awesome program');
% pause;
% 
% 
alphas = ones(1,length(features));
disp('strongclassifying');
imageId = 1;

figure(9);
showFeature(features{1},9);
pause;
showFeature(features{2},9);
pause;
showFeature(features{3},9);
pause;
showFeature(features{4},9);
pause;
showFeature(features{5},9);
pause;
showFeature(features{6},9);
pause;
showFeature(features{7},9);
pause;
showFeature(features{8},9);
pause;

f = {features{1},features{2},features{3},features{4},features{5},features{6},features{7},features{8}};

strongClassify(f, D{imageId}, I{imageId}, R{imageId}, alphas,1);
