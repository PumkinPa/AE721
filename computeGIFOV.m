% inout function GIFOV
function GIFOV_i = computeGIFOV(IFOV_i, eps_i, phi_deg, R_sl)

% convert Phi to Radians
    phi = deg2rad(phi_deg);

    % Ensure both are row vectors for element-wise operations
    IFOV_i = IFOV_i(:).';
    eps_i = eps_i(:).';

% GIFOV Equation
    GIFOV_i = IFOV_i .* (R_sl .* sin(phi)) ./ (sin(phi + eps_i).^2);
end
