function IFOV_i = computeIFOV(eps_i, pixelWidth, focalLength)

    IFOV_i = (pixelWidth ./ focalLength) .* cos(eps_i).^2;
end