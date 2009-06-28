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

	sample = single(sample)/256;

	integrals{1} = sample;

	% creating the image filters
	Fdx = [-1 0 1;-1 0 1;-1 0 1];
	Fdy = Fdx';

	% Get the abs x-derivative (1st order)
	dx = imfilter(sample, Fdx);
	dxAbs = abs(dx);
	integrals{2} = getIntegral(dxAbs);

	% % Get the abs y-derivative (1st order)
	% dy = imfilter(sample, Fdy);
	% dyAbs = abs(dy);
	% integrals{3} = getIntegral(dyAbs);

	% % Get the abs x-derivative (2nd order)
	% dx2Abs = abs(imfilter(imfilter(sample, Fdx), Fdx));
	% integrals{4} = getIntegral(dx2Abs);

	% % Get the abs y-derivative (2nd order)
	% dy2Abs = abs(imfilter(imfilter(sample, Fdy), Fdy));
	% integrals{5} = getIntegral(dy2Abs);

	% precalculate means
	%Fmean = ones(6)/36;
	%dxMean = imfilter(dx, Fmean);
	%dyMean = imfilter(dy, Fmean);

	%% Calculate abs variance of dx
	%integrals{6} = abs(dx - dxMean);
	%integrals{7} = abs(dy - dyMean);

	%% Calculate abs variance of abs dx
	%integrals{8} = abs(dx - abs(dxMean));
	%% Calculate abs variance of abs dy
	%integrals{9} = abs(dy - abs(dyMean));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% getIntegral(sample)
%%
%% INPUTS:
%%  - sample, the image sample
%%
%% OUPUTS:
%%  - integral, the integral image of the sample
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function integral = getIntegral(sample)
	integral = cumsum(cumsum(sample,2));
end
