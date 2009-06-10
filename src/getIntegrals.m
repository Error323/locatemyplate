%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% getIntegrals(sample)
%%
%% INPUTS:
%%  - sample, the image sample
%%
%% OUPUTS:
%%  - integrals, the integral images
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function integrals = getIntegrals(sample)
	integrals = {};

	% Get the abs x-derivative
	Fdx = [-1 0 1;-1 0 1;-1 0 1];
	dxAbs = abs(imfilter(sample, Fdx));
	integrals{1} = cumsum(cumsum(dxAbs,2));

	% Get the abs y-derivative
	Fdy = Fdx';
	dyAbs = abs(imfilter(sample, Fdy));
	integrals{2} = cumsum(cumsum(dyAbs,2));
end