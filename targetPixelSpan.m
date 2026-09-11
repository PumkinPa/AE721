% Gabe Johnson
% This function takes inputs and outputs the half-angle as seen from distance and the number of pixels the target spans.
function [epsTarget, numSpanningPixels] = targetPixelSpan(L_target, r, eps_i)

    epsTarget = atan((L_target / 2) / r);
    numSpanningPixels = sum(abs(eps_i) <= epsTarget);
end
