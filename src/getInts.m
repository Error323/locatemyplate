train = load('../cache/cascader-5.mat');
cascader = train;

nrLayers         = size(cascader.cascader,2);
for layer=1:nrLayers
	layer
	S 					= cascader.cascader{layer};
	nrFeatures 	= size(S.classifier,2);
	for f=1:nrFeatures
			feature = S.classifier{f};
			integralId 	= [integralId feature.int]
	end
end
integralId
for i=1:10
	i,sum(integralId == i)
end

