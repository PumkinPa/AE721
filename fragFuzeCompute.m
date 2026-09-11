function [k, Pd, r_m] = fragFuzeCompute(Do, t_wall, rho_c, rho_m, L_warhead, Ae_ft2, Pd_req)
%FRAGFUZECOMPUTE  Fragment count, damage probability, and fuzing distance.
%
%   INPUTS (imperial units)
%     Do        : warhead outer diameter [in]
%     t_wall    : casing wall thickness [in]
%     rho_c     : explosive density [lbf/in^3]
%     rho_m     : casing material density [lbf/in^3]
%     L_warhead : warhead length [in]
%     Ae_ft2    : target effective area [ft^2] (from target_effective_area)
%     Pd_req    : required damage probability [fraction, e.g. 0.90]
%
%   OUTPUTS
%     k    : number of lethal fragments [-]
%     Pd   : achieved damage probability at r_m [%]
%     r_m  : fuzing distance [m]

    a        = 8400;    % explosive constant
    m_frag   = 30.8647; % minimum lethal fragment mass [grains] (2 g)
    phi_half = 10;      % fragment cone half-angle [deg]
    Omega    = 2*pi*(1 - cosd(phi_half));  % solid angle [sr]

    Di = Do - 2*t_wall;

    density_ratio = rho_c / rho_m;
    weight_ratio  = density_ratio / ((Do/Di)^2 - 1);

    V0 = sqrt((2 * weight_ratio * a) / (2 + weight_ratio));  % fragment velocity [ft/s]
    mo = 60e6 * Do^2 / V0^2;                                 % mean fragment mass [grains]

    % Casing mass: cylindrical shell body + two solid end caps [grains]
    V_body    = pi*(Do^2 - Di^2)/4 * (L_warhead - 2*t_wall);
    V_endcaps = 2 * (pi*Do^2/4) * t_wall;
    M = rho_m * (V_body + V_endcaps) * 7000;  % [grains]

    k = (M / m_frag) * exp(-(2*m_frag/mo)^0.5);  % fragment count [-]

    % Fuzing distance [ft] for required Pd
    r_ft = sqrt(k * Ae_ft2 / (Omega * log(1 / (1 - Pd_req))));
    r_m  = r_ft * 0.3048;  % [m]

    % Verify achieved Pd at r_m
    As = Omega * r_ft^2;
    Pd = (1 - exp(-k * Ae_ft2 / As)) * 100;  % [%]
end
