%% MAIN EXECUTION
clc; clear all; close all;

inputs;


eps_i     = pixelAngles(numPixels, pixelWidth, focalLength);
eps_i_deg = rad2deg(eps_i);
IFOV_i    = computeIFOV(eps_i, pixelWidth, focalLength);

for t = 1:length(targets)
    R_sl    = targets(t).r;
    L       = targets(t).L;

    GIFOV_cell = cell(1, length(phi_vec));

    for k = 1:length(phi_vec)
        GIFOV_cell{k} = computeGIFOV(IFOV_i, eps_i, phi_vec(k), R_sl);

        [epsTarget, numSpanningPixels] = targetPixelSpan(L, R_sl, eps_i);

        fprintf('Target: %s | phi = %d deg | eps_target = %.2f deg | pixels spanning = %d\n', ...
                targets(t).name, phi_vec(k), rad2deg(epsTarget), numSpanningPixels);
    end

    plotGIFOV(eps_i_deg, GIFOV_cell, phi_vec, targets(t).name);
end