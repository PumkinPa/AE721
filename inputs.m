%% Inputs

%% Sensor parameters
numPixels   = 128;
pixelWidth  = 30e-6;  % m
focalLength = 0.05;   % m

%% Warhead parameters (from Section 1 design)
Do        = 5;       % outer diameter [in]
t_wall    = 0.315;   % wall thickness [in]
rho_c     = 0.06141; % explosive density [lbf/in^3]
rho_m     = 0.2836;  % casing material density, steel [lbf/in^3]
L_warhead = 39;      % warhead length [in]
Pd_req    = 0.90;    % required damage probability (90%)
approach_deg = 0;    % approach angle [deg]: 0 = nose-on, 90 = broadside

%% Impact angles
phi_vec = [45, 60, 90];  % [deg]

%% Map design targets to shared library entries
%   Column 1: display name used in main.m
%   Column 2: name in targetLibrary.m
targetMapping = {
    'target 1', 'Drone (Class 3+)';
    'target 2', 'Large Surface-to-Air Missile'
};

libTargets = targetLibrary();
targets = struct('name',{}, 'L',{}, 'r',{});

phi_mean_rad = deg2rad(mean(phi_vec));
approach_rad = deg2rad(approach_deg);

fprintf('\n--- Fuzing distance computation ---\n');
for i = 1:size(targetMapping, 1)
    displayName = targetMapping{i,1};
    libName     = targetMapping{i,2};

    idx = find(strcmp({libTargets.name}, libName));
    if isempty(idx)
        error('Target "%s" not found in targetLibrary.', libName);
    end
    tLib = libTargets(idx);

    % Effective area at mean impact angle and specified approach angle
    Aeff = tLib.Atop   * abs(cos(phi_mean_rad)) + ...
           tLib.Afront * abs(sin(phi_mean_rad) * cos(approach_rad)) + ...
           tLib.Aside  * abs(sin(phi_mean_rad) * sin(approach_rad));

    % Compute fragment count, Pd check, and fuzing distance
    [k, Pd, r] = fragFuzeCompute(Do, t_wall, rho_c, rho_m, L_warhead, Aeff, Pd_req);

    fprintf('  %-10s ("%s")\n', displayName, libName);
    fprintf('    A_eff = %.1f ft^2 | k = %.0f frags | r_fuze = %.2f m | Pd = %.1f%%\n\n', ...
            Aeff, k, r, Pd);

    targets(i).name = displayName;
    targets(i).L    = tLib.L_m;  % characteristic dimension [m]
    targets(i).r    = r;          % fuzing distance [m]
end
fprintf('-----------------------------------\n\n');
