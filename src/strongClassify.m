%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% strongClassify(classifier, alphas, threshold, sample, dimensions)
%%
%% INPUTS:
%%  - classifier, the set of weak classifiers selected by vjBoost
%%  - alphas, their corresponding alphas
%%  - sample, the datapoint (image)
%%  - threshold, play with the confusion matrix
%%  - dimensions, the dimensions of the scanning window
%%
%% OUPUTS:
%%  - C, a matrix of the sample in {0,1}, true or false
%%  - V, the values of the weak classifiers summed
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [C, V] = strongClassify(classifier, alphas, threshold, sample, dimensions)
	% T         = length(classifier);
	% V         = zeros(size(sample) - dimensions);

	% % Create the summed value matrix
	% for t = 1:T
	% 	[C, V_] = weakClassify(classifier{t}, sample, dimensions);
	% 	V = V + alphas(t) * C;
	% end


	% % Create the binary matrix C
	% C = ( V >= ( threshold * sum(alphas) ) );
end
