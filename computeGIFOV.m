function GIFOV_i = computeGIFOV(IFOV_i, eps_i, phi_deg, R_sl)
    % INPUTS:
    %   IFOV_i  : per-pixel IFOV [rad]
    %   eps_i   : per-pixel off-axis angle [rad]
    %   phi_deg : impact angle [deg]
    %   R_sl    : slant range = fuzing distance r [m]
    % OUTPUTS:
    %   GIFOV_i : ground footprint of each pixel [m]

    phi = deg2rad(phi_deg);
    GIFOV_i = IFOV_i .* (R_sl .* sin(phi)) ./ sin(phi + eps_i).^2;
end