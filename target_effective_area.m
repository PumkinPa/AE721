%% Target effective area
%
% Computes and plots the effective (presented) projected area A_eff for
% a library of target types, as seen from an arbitrary viewing direction
% defined by two angles:
%   - Buildings / Radar sites
%   - Ground vehicles (light/medium/heavy trucks)
%   - Small boats
%   - Fixed-wing aircraft (fighters, cargo)
%   - Drones (Class 3+)
%   - Rotary-wing aircraft
%   - Missiles
%
% MODEL 
%   A_eff(elev, az) = A_top   * |cos(elev)|
%                    + A_front * |sin(elev) * cos(az)|
%                    + A_side  * |sin(elev) * sin(az)|
%
%   elev = elevation angle, measured down from straight-down:
%          elev = 0 deg -> looking straight down (pure top view)
%          elev = 90 deg  -> looking level at the horizon (no top face visible)
%   az   = azimuth angle about the vertical axis:
%          az = 0 deg  -> nose/tail-on
%          az = 90 deg -> broadside
%
% DATA SOURCE
% Values are taken directly from calculated face areas where given
% (buildings, radar site, trucks). Where outer dimensions were
% given (aircraft, boats, drones, rotorcraft, missiles), front/side/top
% areas are calculated using the simple approximations. Adjust the tunable

clear; clc; close all;

%% TUNABLE ASSUMPTIONS
fuselageWidthFrac = 0.12;   % ASSUMPTION


% USER INPUT:Pan Angle
% Choose angle 

fprintf('Pan sweep type:\n');
fprintf('  1 = Sweep AZIMUTH (nose <-> side) at a fixed ELEVATION\n');
fprintf('  2 = Sweep ELEVATION (top-down <-> level) at a fixed AZIMUTH\n');
sweepType = input('Enter 1 or 2 [default 1]: ');
if isempty(sweepType)
    sweepType = 1;
end

if sweepType == 1
    fixedElev_deg = input('Enter the fixed elevation angle in deg (0=level, 90=straight down) [default 45]: ');
    if isempty(fixedElev_deg)
        fixedElev_deg = 45;
    end
    az_deg = 0:1:90; % 0 = nose-on, 90 = broadside
    elev_deg = fixedElev_deg * ones(size(az_deg));
    sweepVar_deg = az_deg;
    sweepLabel = sprintf('Azimuth, az (deg)  [elevation fixed at %g deg]', fixedElev_deg);
else
    fixedAz_deg = input('Enter the fixed azimuth angle in deg (0=nose-on, 90=broadside) [default 0]: ');
    if isempty(fixedAz_deg)
        fixedAz_deg = 0;
    end
    elev_deg = 0:1:90; % 0 = level, 0 = straight down
    az_deg = fixedAz_deg * ones(size(elev_deg));
    sweepVar_deg = elev_deg;
    sweepLabel = sprintf('Elevation, elev (deg)  [azimuth fixed at %g deg]', fixedAz_deg);
end

elev_rad = deg2rad(elev_deg);
az_rad = deg2rad(az_deg);

% TARGET LIBRARY
% Each target: name, category, A_front [ft^2], A_side [ft^2], A_top [ft^2]

targets = struct('name', {}, 'category', {}, 'Afront', {}, 'Aside', {}, 'Atop', {}, 'src', {});

% Buildings / fixed infrastructure
targets(end+1) = mkTarget('Building (generic 3-story)', 'Infrastructure', 2200, 2200, 2500, 'S'); % square 50x50 footprint 

targets(end+1) = mkTarget('Radar Site Building (RRH)', 'Infrastructure', 800, 1312, 4100, 'S'); % 50ft face=800, 82ft face=1312, roof=4100

targets(end+1) = mkTarget('Radar Dome (radome)', 'Infrastructure', 1385, 1385, 1385, 'S'); % axisymmetric dome 

% Ground vehicles (trucks)
targets(end+1) = mkTarget('Light Tactical Vehicle', 'Ground Vehicle', 42, 90, 105, 'S');

targets(end+1) = mkTarget('Medium Tactical Vehicle / 2.5-Ton Cargo', 'Ground Vehicle', 80, 250, 200, 'S');

targets(end+1) = mkTarget('Heavy Tactical Truck', 'Ground Vehicle', 80, 350, 280, 'S');

% Small boat 
boatL = 40; boatW = 12; boatH = 5;
targets(end+1) = mkTarget('Small Boat', 'Maritime', boatW*boatH, boatL*boatH, 500, 'D');

% Fixed-wing aircraft (parked)
acft = { ...
    'Small Fighter (parked)', 50, 24, 15, 250; 'Medium-Large Multirole Fighter', 62, 42, 18, 550; 'Large Cargo Plane', 140,150, 45, 2500 };

for i = 1:size(acft,1)
    name = acft{i,1}; L = acft{i,2}; span = acft{i,3}; H = acft{i,4}; Awing = acft{i,5};
    Aside = L*H;
    Afront = H * (fuselageWidthFrac*span);
    targets(end+1) = mkTarget(name, 'Fixed-Wing Aircraft', Afront, Aside, Awing, 'D');
end

% Drone (Class 3+) 
% Same approximation approach as fixed-wing aircraft above

droneL = 35; droneSpan = 60; droneH = 8; droneWing = 175;
targets(end+1) = mkTarget('Drone (Class 3+)', 'Air Threat', droneH*(fuselageWidthFrac*droneSpan), droneL*droneH, droneWing, 'D');

% Rotorcraft (medium)

rotL = 50; rotD = 55; rotH = 16; rotW = 8;
targets(end+1) = mkTarget('Rotorcraft (medium)', 'Air Threat', rotW*rotH, rotL*rotH, (pi/4)*rotD^2, 'D');

% Missiles (modeled as cylinders: front = circular cross-section,
%     side = length*diameter, top = same as side by axisymmetry)
missiles = { 'Small Air-to-Air Missile', 7/12,  10;'Small Surface-to-Air Missile', 3.5/12, 5;'Large Surface-to-Air Missile', 15/12, 25};

for i = 1:size(missiles,1)
    name = missiles{i,1}; d = missiles{i,2}; L = missiles{i,3};
    Afront = (pi/4)*d^2;
    Aside = L*d;
    targets(end+1) = mkTarget(name, 'Missile', Afront, Aside, Aside, 'D');
end

%% COMPUTE EFFECTIVE AREA CURVES
for i = 1:numel(targets)
    top_term   = targets(i).Atop   .* abs(cos(elev_rad));
    front_term = targets(i).Afront .* abs(sin(elev_rad) .* cos(az_rad));
    side_term  = targets(i).Aside  .* abs(sin(elev_rad) .* sin(az_rad));
    targets(i).Aeff = top_term + front_term + side_term;
end

% PRINT SUMMARY TABLE
fprintf('%-42s %-20s %10s %10s %10s %5s\n', 'Name','Category','A_front','A_side','A_top','Src');
fprintf('%s\n', repmat('-',1,100));
for i = 1:numel(targets)
    t = targets(i);
    fprintf('%-42s %-20s %10.1f %10.1f %10.1f %5s\n', t.name, t.category, t.Afront, t.Aside, t.Atop, t.src);
end

%% PLOTS
categories = unique({targets.category}, 'stable');
for c = 1:numel(categories)
    cat = categories{c};
    idx = find(strcmp({targets.category}, cat));

    figure('Color','w','Name',cat);
    hold on;
    for k = idx
        plot(sweepVar_deg, targets(k).Aeff, 'LineWidth', 2, 'DisplayName', targets(k).name);
    end
    hold off;
    grid on;
    xlabel(sweepLabel);
    ylabel('Effective area, A_{eff} (ft^2)');
    title(['Effective Area vs. Pan - ' cat]);
    xlim([min(sweepVar_deg) max(sweepVar_deg)]);
    legend('Location','bestoutside');
end

%% HELPER FUNCTION 
function t = mkTarget(name, category, Afront, Aside, Atop, src)
    t.name = name;
    t.category = category;
    t.Afront = Afront;
    t.Aside = Aside;
    t.Atop = Atop;
    t.src = src;
end
