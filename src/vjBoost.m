%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% vjBoost(data, features, T)
%%
%% INPUTS:
%%  - data, data.x{i} the image, data.y(i) in {0, 1} pos or neg sample
%%  - features, the list of generated features
%%  - T, number of best features
%%
%% OUPUTS:
%%  - strongClassifier, the T best features
%%  - alphas, their corresponding weights
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [strongClassifier, alphas] = vjBoost(data, features, T)
	% Discriminate positive and negative samples
	pos = (data.y == 1);
	neg = (data.y == 0);
	N   = size(data.y, 2);

	% Initialize some vars
	I      = zeros(1, T);
	alphas = zeros(1, T);
	W      = ones(1, N);
	E      = ones(1, N);
	Ep     = ones(1, N);
	H      = size(features, 2);

    % Initialize the sample weights distribution
    m      = length(find(neg == 1));
    l      = length(find(pos == 1));
	W(neg) = W(neg) ./ (2*m);
	W(pos) = W(pos) ./ (l);

	for t = 1:T
		% Normalize the weights
		W = W ./ sum(W);

		% Select the best feature
		Et = inf; Ht = 1;
		for h = 1:H
			% Ignore features already selected
			if (length(I(I == h)) == 1)
				continue;
			end

			s = 0;
			for i = 1:l+m
				Ep(i) = weakClassify(features{h}, data.x{i}, data.intImg{i});
				s     = s + W(i) * abs( Ep(i) - data.y(i) );
			end
			if (s < Et)
				Et = s;
				Ht = h;
				E  = Ep;
			end
		end

		% Store the index to the best feature at place t
		I(t) = Ht;

		% Update the weights
		beta = Et / ( 1 - Et );
		W = W .* ( beta .^ E );

		% Calculate alpha weight
		alphas(t) = log(1./beta);
		fprintf('learning: %0.2f%% complete', t/T*100);
	end

	% Output the T best features
	strongClassifier = features(I);
end
