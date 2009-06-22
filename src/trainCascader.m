%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% trainCascader(f, d, Ftarget)
%%
%% INPUTS:
%%  - f, maximum acceptable false positive rate per layer
%%  - d, minimum acceptable detection rate per layer
%%  - Ftarget, overall false positive rate
%%
%% OUPUTS:
%%  - cascader, a cascading classifier
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function cascader = trainCascader(f, d, Ftarget)
	cascader = {};

	P = getData('pos');  % Positive samples
	N = getData('neg');  % Negative samples
	V = getData('both'); % Validation set

	Fprev = 1; Dprev = 1; i = 0;

	% Create a cascading classifier made out of strong classifiers
	while (Fcur > Ftarget)
		i = i + 1;
		ni = 0;
		Fcur = Fprev;

		% Create the current layer
		while (Fcur > f*Fprev)
			ni = ni + 1;
			[strong, alphas] = vjBoost(P, N, features, ni);

			layer.classifier = strong;
			layer.alphas     = alphas;
			cascader{i}      = layer;

			% Determine the best threshold for the current layer
			for t = 0.9:-0.1:0.1
				cascader{i}.threshold = t;
				[Fcur, Dcur, N_] = evaluate(cascader, V);
				if (Dcur > d*Dprev)
					break;
				end
			end
		end

		if (Fcur > Ftarget)
			% Implicit empty and replace N
			[Fcur, Dcur, N] = evaluate(cascader, V);
		end

		Dprev = Dcur;
		Fprev = Fcur;
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
%%  - n, the false positives
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [f, d, n] = evaluate(cascader, validation)
	fp = 0; tp = 0; tn = 0; fn = 0;
	totalP = 0; totalN = 0;

	for i = 1:length(validation)
		V = validation{i};
		C = classify(cascader, V);
		for j = 1:length(V.tags)
			x   = V.x(j);
			y   = V.y(j);
			tag = V.tags(j);

			% Positive zone
			if (tag == 1)
				if (C(y,x) == tag)
					tp = tp + 1;
				else
					fp = fp + 1;
				end
				totalP = totalP + 1;

			% Negative zone
			else
				if (C(y,x) == tag)
					tn = tn + 1;
				else
					fn = fn + 1;
				end
				totalN = totalN + 1;
			end
		end
	end
	f = fp / totalN;
	d = tp / totalP;
end
