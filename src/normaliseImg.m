function VNormalised  = normaliseImg(V)
	% normalise img
	VMin = min(min(V));
	VMax = max(max(V));
	VRange = VMax-VMin;
	VNormalised = (V - VMin)/VRange;
end
