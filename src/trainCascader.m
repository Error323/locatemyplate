%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% trainCascader(f, d, Ftarget, train, validate, features)
%%
%% INPUTS:
%%  - f, maximum acceptable false positive rate per layer should be fairly high
%%  - d, minimum acceptable detection rate per layer should be really high
%%  - Ftarget, overall false positive rate should be really low
%%  - train, [I, P, N, D] the trainingsset
%%  - validate, [I, P, N, D] the validateset
%%  - features, the untrained generated features
%%
%% OUPUTS:
%%  - cascader, a cascading classifier
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cascader = trainCascader(f, d, Ftarget, train, validate, features)
	cascader = {};

	Fprev = 1; Dprev = 1; Dcur = 1;
 	i = 0;
	% Create a cascading classifier made out of strong classifiers
	while (Fprev > Ftarget)
		ni = 0;
		i = i + 1;
		Fcur = Fprev;

		% Re-train the features using the false positives
		for j = 1:length(features)
			features{j} = trainWeakClassifier(features{j}, train);
			fprintf('training features %0.2f%% complete\n', (j/length(features)*100));
		end

		% Create a new layer
		while (Fcur > f*Fprev || Dcur < d*Dprev)
			ni = ni + 1;

			[strong, alphas] = vjBoost(train, features, ni);

			cascader{i}.classifier = strong;
			cascader{i}.alphas     = alphas;

			% Determine the best threshold for the current layer
			for t = 0.9:-0.1:0.1
				cascader{i}.threshold = t;
				[Fcur, Dcur, N_] = evaluate(cascader, validate);
				fprintf('d = %0.2f, fp = %0.2f\n', Dcur, Fcur);
				if (Dcur > d*Dprev)
					break;
				end
			end
		end

		if (Fcur > Ftarget)
			% Implicit empty and replace N
			[Fcur_, Dcur_, train.N] = evaluate(cascader, train);
		end

		fprintf('layer %d complete, %d features, d = %0.2f, fp = %0.2f\n', i, length(cascader{i}.classifier), Dcur, Fcur);

		Dprev = Dcur;
		Fprev = Fcur;
		fprintf('Saving current cascader with %d layers\n', i);
		save('../cache/cascader.mat', 'cascader');
	end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% evaluate(cascader, validation)
%%
%% INPUTS:
%%  - cascader, the cascading classifier
%%  - validation, the validation set
%%
%% OUPUTS:
%%  - f, the false positive rate
%%  - d, the detection rate
%%  - N, the false positives
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [f, d, N] = evaluate(cascader, validation)
	I = validation.I; % True images
	P = validation.P; % Binary images for positive samples
	N = validation.N; % Binary images for negative samples
	D = validation.D; % Dimension of license plate per image

	fP = 0; tP = 0; fN = 0; tN = 0;
	for i = 1:length(I)
		[Ci, Vi_] = classify(cascader, I{i}, D{i});
		Pi = P{i};
		Ni = N{i};

		TP =  Ci & Pi; % tp =  C and P
		FP =  Ci & Ni; % fp =  C and N
		TN = ~Ci & Ni; % tn = !C and N
		FN = ~Ci & Pi; % fn = !C and P

		fP = fP + sum(sum(FP));
		tP = tP + sum(sum(TP));
		fN = fN + sum(sum(FN));
		tN = tN + sum(sum(TN));

		% Set the new negative set to the false positives
		N{i} = FP;
	end
	f = fP / (fP + tN);
	d = tP / (tP + fN);
end
