function eps_i = pixelAngles(numPixels, pixelWidth, focalLength) %Declan Kurtz

    pixelIndex = (-(numPixels-1)/2 : (numPixels-1)/2);   % symmetric index
    eps_i = atan(pixelIndex .* pixelWidth ./ focalLength); %anglular pixel location in radians
end
