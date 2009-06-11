%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% strongClassify(C, alphas, x, integrals)
%%
%% INPUTS:
%%  - C, the set of weak classifiers selected by vjBoost
%%  - alphas, their corresponding alphas
%%  - x, the datapoint (image)
%%
%% OUPUTS:
%%  - c, in {0,1}, true or false
%%  - v, the value of this datapoint
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [c, v] = strongClassify(C, alphas, x)
	integrals = getIntegrals(x);
	T         = size(C, 2);
	v         = 0;

	for t = 1:T
		[c, v_] = weakClassify(C{t}, x, integrals);
		v = v + alphas(t) * c;
	end

	if (v >= 0.5 * sum(alphas))
		c = 1;
	else
		c = 0;
	end
end
