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

	P = getData(); % Positive samples
	N = getData(); % Negative samples
	V = getData(); % Validation set

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
	f = 0;
	d = 0;
	n = {};
end
