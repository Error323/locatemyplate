%%%%% GLOBAL CONSTANTS %%%%%
global INTEGRALS SEGMENTS DEBUG SCALEFACTOR MAXSAMPLES INTLABELS;

% Number of integral images
INTEGRALS   = [2 3 4 5];

INTLABELS   = {'image itself', 'abs dx', 'abs dy', 'abs ddx', 'abs ddy', 'abs var dx', 'abs var dy', 'abs var abs dx', 'abs var abs dy'};

% Number of segments/blocks within a feature
SEGMENTS    = 5;

% Maximal number of negative samples per image for weaktrainer
MAXSAMPLES  = 50;

% Show debug information
DEBUG       = false;

% Scaling factor on train and validate data
SCALEFACTOR = 0.5;
