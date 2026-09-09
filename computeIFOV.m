function IFOV_i = computeIFOV(eps_i, w_pixel, f)
    % INPUTS:
    %   eps_i   : per-pixel off-axis angle [rad]
    %   w_pixel : pixel pitch [m]
    %   f       : focal length [m]
    % OUTPUTS:
    %   IFOV_i  : instantaneous FOV of each pixel [rad]

    IFOV_i = (w_pixel ./ f) .* cos(eps_i).^2;
end