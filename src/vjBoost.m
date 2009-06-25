%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% vjBoost(data, features, T)
%%
%% INPUTS:
%%  - data, [I,P,N,D]
%%  - features, the list of generated features
%%  - T, number of best features
%%
%% OUPUTS:
%%  - strongClassifier, the T best features
%%  - alphas, their corresponding weights
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [strongClassifier, alphas] = vjBoost(data, features, T)
	global INTEGRALS;
	I = data.I;
	P = data.P;
	N = data.N;
	D = data.D;

	%for i=1:length(features)
	%	features{i} = trainWeakClassifier(features{i}, data);
	%	fprintf('training %0.2f%% complete\n', (i/length(features)*100));
	%end

	for i=1:length(I)
		for j=2:INTEGRALS
			R{i}{j} = {};
		end
	end

	% Initialize matrices
	pos = 0; neg = 0;
	W   = {};
	E   = {};
	Ep  = {};
	for i = 1:length(I)
		pos  = pos + sum(sum(P{i}));
		neg  = neg + sum(sum(N{i}));
		W{i} = zeros(size(P{i}));
	end

	% Initialize weight matrices
	for i = 1:length(I)
		W{i}(find(P{i} == 1)) ./ (2*pos);
		W{i}(find(N{i} == 1)) ./ (2*neg);
	end

	% Initialize some vars
	IDX    = zeros(1, T);
	alphas = zeros(1, T);
	H      = length(features);

	for t = 1:T
		% total sum of the weights
		wSum = 0;
		for i = 1:length(I)
			wSum = wSum + sum(sum(W{i}));
		end

		% Normalize the weights
		for i = 1:length(I)
			W{i} = W{i} ./ wSum;
		end

		% Select the best feature
		Et = inf; Ht = 1;
		for h = 1:H
			% Ignore features already selected
			if (length(IDX(IDX == h)) == 1)
				continue;
			end

			s = 0;
			for i = 1:length(I)
				[C, R, V] = weakClassify(features{h}, D{i}, I, i, features{h}.int, R);
				d = D{i}
				p = size(P{i})
				img = size(I{i}{1})
				c = size(C)
				figure;imshow(P{i});
				figure;imshow(I{i}{1});
				Ep{i}  = xor(C,P{i}); % C xor P gives all errors
				s      = s + sum(sum(W{i} .* Ep{i}));
			end
			if (s < Et)
				Et = s;
				Ht = h;
				E  = Ep;
			end
		end

		% Store the index to the best feature at place t
		IDX(t) = Ht;

		% Update the weights
		beta = Et / ( 1 - Et );
		for i = 1:length(I)
			W{i} = W{i} .* ( beta .^ ( 1 - E{i} ) );
		end

		% Calculate alpha weight
		alphas(t) = log(1./beta);
		fprintf('learning: %0.2f%% complete\n', t/T*100);
	end

	% Output the T best features
	strongClassifier = features(IDX);
end
