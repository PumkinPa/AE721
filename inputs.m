%% SECTION 2 MASTER SCRIPT


%% ---- SENSOR PARAMETERS (your design choices) ----
N        = 128;          % total pixels [-]
w_pixel  = 30e-6;        % pixel pitch [m]
f        = 0.05;         % focal length [m]

%% ---- TARGET DATA (from Section 1) ----
% One fuzing distance r per target from your Step 5
% One characteristic dimension L per target from target study
targets(1).name  = 'Missile 1';
targets(1).L     = 20;     % [m], target dimension from study
targets(1).r     = 10;     % [m], fuzing distance from Sec 1

targets(2).name  = 'Drone 1';
targets(2).L     = 10;
targets(2).r     = 10;
% etc.

phi_vec = [45, 60, 90];   % impact angles [deg]