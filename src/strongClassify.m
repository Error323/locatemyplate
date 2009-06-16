%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% strongClassify(C, alphas, x, threshold)
%%
%% INPUTS:
%%  - C, the set of weak classifiers selected by vjBoost
%%  - alphas, their corresponding alphas
%%  - x, the datapoint (image)
%%  - threshold, play with the confusion matrix
%%
%% OUPUTS:
%%  - c, in {0,1}, true or false
%%  - v, the value of this datapoint
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [c, v] = strongClassify(C, alphas, x, threshold)
	integrals = getIntegrals(x);
	T         = length(C);
	v         = 0;

	for t = 1:T
		[c, v_] = weakClassify(C{t}, x, integrals);
		v = v + alphas(t) * c;
	end

	if (v >= threshold * sum(alphas))
		c = 1;
	else
		c = 0;
	end
end
