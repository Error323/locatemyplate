%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% randi(integer)
%%
%% INPUTS:
%%  - integer, 
%% OUPUTS:
%%  - random number between 0 and integer
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function r = randi(i)
	r = floor(rand()*i)+1;
end
