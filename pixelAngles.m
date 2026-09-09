function eps_i = pixelAngles(N, w_pixel, f)
    % INPUTS:
    %   N       : number of pixels [-]
    %   w_pixel : pixel pitch [m]
    %   f       : focal length [m]
    % OUTPUTS:
    %   eps_i   : off-axis angle of each pixel [rad], length N

    i_vals = (-(N-1)/2 : (N-1)/2);   % symmetric index
    eps_i  = atan(i_vals .* w_pixel ./ f);
end