%% Inputs
%% Sensor parameters
num_pixels       = 128;          
pixel_pitch  = 30e-6;% m
focal_length        = 0.05;% m

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