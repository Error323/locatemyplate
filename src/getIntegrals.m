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

	% creating the image filters
	Fdx = [-1 0 1;-1 0 1;-1 0 1];
	Fdy = Fdx';

	% Get the abs x-derivative (1st order)
	dx = imfilter(sample, Fdx);
	dxAbs = abs(dx);
	integrals{1} = getIntegral(dxAbs);

	% Get the abs y-derivative (1st order)
	dy = imfilter(sample, Fdy);
	dyAbs = abs(dy);
	integrals{2} = getIntegral(dyAbs);

	% Get the abs x-derivative (2nd order)
	dx2Abs = abs(imfilter(imfilter(sample, Fdx), Fdx));
	integrals{3} = getIntegral(dx2Abs);

	% Get the abs y-derivative (2nd order)
	dy2Abs = abs(imfilter(imfilter(sample, Fdy), Fdy));
	integrals{4} = getIntegral(dy2Abs);

	% precalculate means
	Fmean = ones(6)/36;
	dxMean = imfilter(dx, Fmean);
	dyMean = imfilter(dy, Fmean);

	% Calculate abs variance of dx
	integrals{5} = abs(dx - dxMean);
	integrals{6} = abs(dy - dyMean);

	% Calculate abs variance of abs dx
	integrals{7} = abs(dx - abs(dxMean));
	% Calculate abs variance of abs dy
	integrals{8} = abs(dy - abs(dyMean));
end
