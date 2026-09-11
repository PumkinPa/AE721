function GIFOV_i = computeGIFOV(IFOV_i, eps_i, phi_deg, R_sl)

    phi = deg2rad(phi_deg);
    GIFOV_i = IFOV_i .* (R_sl .* sin(phi)) ./ sin(phi + eps_i).^2;
end