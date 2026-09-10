% Fragment Study 
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
rho_c =  0.060694; % Explosive Density [lbf/in3] 
% Explosive Densities Used PBXN-109 meets the 10 yr storage requirement
rho_m = [0.2836; 0.16004 ;0.06900]; % Material Density [lbf/in3] 
% Material Densities Used are AISI 4340 Steel, Ti-6Al-4V Titanium, 7075-T6
m = 92.59; % grains  . This is 6 grams. This matches the minimum fragmentation study in 
% which the 8 mm is the minimum size that allows for hitting all RFP targets.
L = 39; % 39.37 in = 1 meter which is the maximum allowable length in RFP

function k = compute_fragment(Do,rho_c,rho_m,L,t,m)
% Inputs 
% Do: Outer Diameter [Inches]
% rho_c: Explosive Density [lbf/in^3]
% rho_m: Material Density [lbf/in^3]
% L: Length of missile [Inches]

% Constants
C = 60.*10.^6; % constant of multiplication - unitless
a = 8400; % explosive constant


Di = Do-2.*t; % inner diameter (inches);
density_ratio = rho_c./rho_m; % Density Ratio
weight_ratio = density_ratio.*1./((Do.^2)./(Di.^2)-1); % Weight Ratio
V0 = sqrt((2.*weight_ratio.*a)./(2+weight_ratio)); % fragment velocity [ft/s]
mo = C.*Do.^2./V0.^2; % Average Weight of Fragments [grains]

% Weight of the metal casing (Cylindrical)
M = (rho_m.*((L-2.*t).*((((pi.*Do.^2)./4)-(pi.*Di.^2)./4)+(2.*t.*(pi.*Do.^2)./4)))).*7000; % grains

% Outputs
% # of Fragments
K = 1./m.*M.*exp(-1.*(2.*m./mo).^0.5); % unitless
end
