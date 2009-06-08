% TODO horizontal/vertical parameter
function f = featureGeneration(nrSegments) 
	
	% counting the decimal value of 1111... (of length nrSegments)
	maxDecimal = 0;
	for i = 0:nrSegments-1
		maxDecimal = maxDecimal + 2^i;
	end

	% initialise array
	binFeature = [];
	% generating maxDecimal+1 features
	% for i = 0:maxDecimal
	% nr Segments = 7
	for i = 61:maxDecimal
		s = dec2bin(i);
		% todo convert string to array
		% TODO should be in cleaner way without for loop
		for j=length(s):-1:1
			% offset is needed to make a 1 a 00000..01
			offset = nrSegments-length(s);
			index = j+offset;
			binFeature(index) = str2num(s(j));
		end
		binFeature
		pause


	
		k = 1;
		while( k<length(binFeature) )
			disp('----------')
			k;
			binFeatureScaled(k) = (k-1)
			binary = binFeature(k);
			holeLength = 1;
			k = k + 1;

			bHoleDetected = 0
			while(binary == binFeature(k))
				bHoleDetected = 1
				disp('holedetect')	
				holeLength = holeLength + 1;
				k = k + 1;
			end
			if(bHoleDetected)
				k = k - 1;
			end
			k;
			holeLength
			%index2 = k-holeLength+1
			pause
		end

		% add last
		binFeatureScaled(k) = (k-1);
		% remove zeros
		binFeatureScaled = binFeatureScaled( binFeatureScaled ~= 0 );
		% add zero to beginning
		binFeatureScaled = [0 binFeatureScaled];
		binFeatureScaled 
		
		% scale to fraction
		fraction = 1/nrSegments;
		binFeatureScaled = binFeatureScaled * fraction;
		binFeatureScaled 
		disp(' ja stop maar')
		pause


		% reset
		clear binFeature;
		clear binFeatureScaled;

	end

	


end
