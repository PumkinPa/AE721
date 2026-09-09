function [eps_target, n_pixels] = targetPixelSpan(L_target, r, eps_i)
    % INPUTS:
    %   L_target : target characteristic dimension [m]
    %   r        : fuzing distance / slant range [m]
    %   eps_i    : per-pixel off-axis angle vector [rad]
    % OUTPUTS:
    %   eps_target : half-angle subtended by target [rad]
    %   n_pixels   : number of pixels spanning the target [-]

    eps_target = atan((L_target / 2) / r);
    n_pixels   = sum(abs(eps_i) <= eps_target);
end