function targets = targetLibrary()
%TARGETLIBRARY  Shared target geometry used by target_effective_area and inputs.
%   Returns struct array with face areas [ft^2] and characteristic length L_m [m].

    fuselageWidthFrac = 0.12;
    ft2m = 0.3048;

    targets = struct('name',{}, 'category',{}, 'Afront',{}, 'Aside',{}, 'Atop',{}, 'src',{}, 'L_m',{});

    % Infrastructure
    targets(end+1) = mkT('Building (generic 3-story)', 'Infrastructure', 2200,  2200,  2500,  'S', 50*ft2m);
    targets(end+1) = mkT('Radar Site Building (RRH)',  'Infrastructure',  800,  1312,  4100,  'S', 82*ft2m);
    targets(end+1) = mkT('Radar Dome (radome)',         'Infrastructure', 1385,  1385,  1385,  'S', 42*ft2m);

    % Ground vehicles
    targets(end+1) = mkT('Light Tactical Vehicle',                    'Ground Vehicle',  42,   90,  105,  'S', 15*ft2m);
    targets(end+1) = mkT('Medium Tactical Vehicle / 2.5-Ton Cargo',  'Ground Vehicle',  80,  250,  200,  'S', 22*ft2m);
    targets(end+1) = mkT('Heavy Tactical Truck',                      'Ground Vehicle',  80,  350,  280,  'S', 25*ft2m);

    % Small boat
    boatL = 40; boatW = 12; boatH = 5;
    targets(end+1) = mkT('Small Boat', 'Maritime', boatW*boatH, boatL*boatH, 500, 'D', boatL*ft2m);

    % Fixed-wing aircraft
    acft = {'Small Fighter (parked)',          50,  24, 15,  250; ...
            'Medium-Large Multirole Fighter',  62,  42, 18,  550; ...
            'Large Cargo Plane',             140, 150, 45, 2500};
    for i = 1:size(acft,1)
        name  = acft{i,1}; L = acft{i,2}; span = acft{i,3};
        H     = acft{i,4}; Awing = acft{i,5};
        targets(end+1) = mkT(name, 'Fixed-Wing Aircraft', ...
            H*(fuselageWidthFrac*span), L*H, Awing, 'D', max(L,span)*ft2m);
    end

    % Drone (Class 3+)
    droneL = 35; droneSpan = 60; droneH = 8; droneWing = 175;
    targets(end+1) = mkT('Drone (Class 3+)', 'Air Threat', ...
        droneH*(fuselageWidthFrac*droneSpan), droneL*droneH, droneWing, 'D', droneL*ft2m);

    % Rotorcraft
    rotL = 50; rotD = 55; rotH = 16; rotW = 8;
    targets(end+1) = mkT('Rotorcraft (medium)', 'Air Threat', ...
        rotW*rotH, rotL*rotH, (pi/4)*rotD^2, 'D', rotL*ft2m);

    % Missiles (cylinders)
    missiles = {'Small Air-to-Air Missile',     7/12,  10; ...
                'Small Surface-to-Air Missile', 3.5/12,  5; ...
                'Large Surface-to-Air Missile', 15/12, 25};
    for i = 1:size(missiles,1)
        name = missiles{i,1}; d = missiles{i,2}; L = missiles{i,3};
        Afront = (pi/4)*d^2;
        Aside  = L*d;
        targets(end+1) = mkT(name, 'Missile', Afront, Aside, Aside, 'D', L*ft2m);
    end
end

function t = mkT(name, category, Afront, Aside, Atop, src, L_m)
    t.name     = name;
    t.category = category;
    t.Afront   = Afront;  % ft^2
    t.Aside    = Aside;   % ft^2
    t.Atop     = Atop;    % ft^2
    t.src      = src;
    t.L_m      = L_m;     % m
end
