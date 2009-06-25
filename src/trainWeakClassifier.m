%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% trainWeakClassifier(feature, data, m, l)
%%
%% INPUTS:
%%  - feature, the current feature being trained
%%  - data, [I, P, N, D]
%%
%% OUPUTS:
%%  - feature, sets the threshold and wether its a positive
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function feature = trainWeakClassifier(feature, data)
	global INTEGRALS DEBUG
	I = data.I;
	P = data.P;
	N = data.N;
	D = data.D;

	for i=1:length(I)
		for j=2:INTEGRALS
			R{i}{j} = {};
		end
	end

	values = [];
	for i=1:length(I)
		[C_, R, V] = weakClassify(feature, D{i}, I, i, feature.int, R);
		[v_, idx]  = find(P{i} == 1);
		values = [values V(idx)];
	end

	feature.threshold = sqrt(mean(values .^ 2));
	if (length(find(values >= feature.threshold)) >= length(values)/2)
		feature.positive = true;
	else
		feature.positive = false;
	end

	if (DEBUG)
		discriminant = ones(1,length(values))*feature.threshold;
		plot(values);
		hold on;
		plot(discriminant, 'r');
		hold off;
		pause;
	end
end
