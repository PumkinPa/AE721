% Fragment Study, Damage Probability and Fuze Distance
clc, clear, close

function [k,Pd,r] = Fragment_Fuze_Compute(Do,rho_c,rho_m,m,L,t_wall,phi_half,Ae,As)
% Inputs 
% Do : Outer Diameter [Inches]
% rho_c : Explosive Density [lbf/in^3]
% rho_m : Material Density [lbf/in^3]
% m: minimum fragmentation size [grains]
% L : Length of missile [Inches]
% Ae : Effective Areas
% As : Frag Surface Area [m^2 or ft^2]

% Constants
Di = Do-2.*t_wall; % inner diameter (inches);
density_ratio = rho_c./rho_m; % Density Ratio
weight_ratio = density_ratio.*1./((Do.^2)./(Di.^2)-1); % Weight Ratio
V0 = sqrt((2.*weight_ratio.*8400)./(2+weight_ratio)); % fragment velocity [ft/s]
mo = 60.*10.^6.*Do.^2./V0.^2; % Average Weight of Fragments [grains]
% Weight of the metal casing (Cylindrical)
M = (rho_m.*((L-2.*t_wall).*((((pi.*Do.^2)./4)-(pi.*Di.^2)./4)+(2.*t_wall.*(pi.*Do.^2)./4)))).*7000; % grains
Omega = 2.*pi.*(1-cosd(phi_half)); % [steradian] Frag Solid Angle

% Output
% # of Fragments
k = 1./m.*M.*exp(-1.*(2.*m./mo).^0.5); % unitless
Pd = (1 - exp(-((k.*Ae)./(As))))*100; % [%] Damage Probability
r = sqrt((k.*Ae)./Omega./log(1/(1-Pd))); % [m or ft] fuzing distance

end
