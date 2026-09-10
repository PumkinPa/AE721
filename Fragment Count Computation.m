% Fragment Study, Damage Probability and Fuze Distance
clc, clear, close
% Computes number of fragments of the warhead as a function based on the
% function of the diameter ratio, weight, density of three materials

% Fragment Velocity

% Max outer diameter comes from the necessity of being able to work with
% 155 mm gun systems (6.1 inches) and a 5 inch navy gun sys with a sabot
% there will be one diameter ratio as there is a minimum thickness that
% will allow penetration of all targets with a Pd >= 90%.

Do = 5; % [inches] outer diameter. WITH SABOT SLEEVE
t = 0.315; % [inches] % thickness of casing 5/16 of an inch based upon maximum thickness 
% required for target with Pd >= 90%
rho_c =  0.06141; % Explosive Density [lbf/in3] 
rho_m = [0.2836; 0.16004 ;0.06900]; % Material Density [lbf/in3] 
% Material Densities Used are AISI 4340 Steel, Ti-6Al-4V Titanium, 7075-T6

L = 39; % 39.37 in = 1 meter which is the maximum allowable length in RFP

function [k,Pd,r] = Fragment_Fuze_Compute(Do,rho_c,rho_m,L,t,Ae,As)
% Inputs 
% Do : Outer Diameter [Inches]
% rho_c : Explosive Density [lbf/in^3]
% rho_m : Material Density [lbf/in^3]
% L : Length of missile [Inches]
% Ae : Effective Areas
% As : Frag Surface Area [m^2 or ft^2]

% Constants
C = 60.*10.^6; % constant of multiplication - unitless
a = 8400; % explosive constant


Di = Do-2.*t; % inner diameter (inches);
density_ratio = rho_c./rho_m; % Density Ratio
weight_ratio = density_ratio.*1./((Do.^2)./(Di.^2)-1); % Weight Ratio
V0 = sqrt((2.*weight_ratio.*a)./(2+weight_ratio)); % fragment velocity [ft/s]
mo = C.*Do.^2./V0.^2; % Average Weight of Fragments [grains]
m = 30.8647; % grains (2 grams)
% Weight of the metal casing (Cylindrical)
M = (rho_m.*((L-2.*t).*((((pi.*Do.^2)./4)-(pi.*Di.^2)./4)+(2.*t.*(pi.*Do.^2)./4)))).*7000; % grains
phi_half = 10; % [degrees] Provided Angle 
Omega = 2.*pi.*(1-cosd(phi_half)); % [steradian] Frag Solid Angle

% Output
% # of Fragments
k = 1./m.*M.*exp(-1.*(2.*m./mo).^0.5); % unitless
Pd = (1 - exp(-((k.*Ae)./(As))))*100; % [%] Damage Probability
r = sqrt((k.*Ae)./Omega./log(1/(1-Pd))); % [m or ft] fuzing distance

end
