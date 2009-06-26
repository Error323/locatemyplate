function demo(i)
	if (~exist('test', 'var'))
		globals;
		load('../cache/cascader-1.mat');
	end
	close all;
	figure(3);
	imshow(test.I{i}{1});
	C = classify(cascader, test.I{i}, test.D{i});
end
