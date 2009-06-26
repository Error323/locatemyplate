if (~exist('test', 'var'))
	globals;
	load('../cache/cascader-1.mat');
end
close all;
figure(3);
imshow(test.I{1}{1});
C = classify(cascader, test.I{1}, test.D{1});
