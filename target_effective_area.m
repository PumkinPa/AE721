%% Target effective area

clc; close all;

% USER INPUT: Pan Angle
% Choose angle

fprintf('Pan sweep type:\n');
fprintf('  1 = Sweep APPROACH ANGLE (nose <-> side) at a fixed IMPACT ANGLE\n');
fprintf('  2 = Sweep IMPACT ANGLE (top-down <-> level) at a fixed APPROACH ANGLE\n');
sweepType = input('Enter 1 or 2 [default 1]: ');
if isempty(sweepType)
    sweepType = 1;
end

if sweepType == 1
    fixedImpact_deg = input('Enter the fixed impact angle in deg (0=level, 90=straight down) [default 45]: ');
    if isempty(fixedImpact_deg)
        fixedImpact_deg = 45;
    end
    approach_deg = 0:1:90; % 0 = nose-on, 90 = broadside
    impact_deg = fixedImpact_deg * ones(size(approach_deg));
    sweepVar_deg = approach_deg;
    sweepLabel = sprintf('Approach Angle (deg)  [impact angle fixed at %g deg]', fixedImpact_deg);
else
    fixedApproach_deg = input('Enter the fixed approach angle in deg (0=nose-on, 90=broadside) [default 0]: ');
    if isempty(fixedApproach_deg)
        fixedApproach_deg = 0;
    end
    impact_deg = 0:1:90; % 0 = level, 90 = straight down
    approach_deg = fixedApproach_deg * ones(size(impact_deg));
    sweepVar_deg = impact_deg;
    sweepLabel = sprintf('Impact Angle (deg)  [approach angle fixed at %g deg]', fixedApproach_deg);
end

impact_rad = deg2rad(impact_deg);
approach_rad = deg2rad(approach_deg);

%% Load shared target library
targets = targetLibrary();

%% COMPUTE EFFECTIVE AREA CURVES
for i = 1:numel(targets)
    top_term   = targets(i).Atop   .* abs(cos(impact_rad));
    front_term = targets(i).Afront .* abs(sin(impact_rad) .* cos(approach_rad));
    side_term  = targets(i).Aside  .* abs(sin(impact_rad) .* sin(approach_rad));
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
    xlabel(sweepLabel, 'FontWeight', 'bold', 'Color', 'k');
    ylabel('Effective area, A_{eff} (ft^2)', 'FontWeight', 'bold', 'Color', 'k');
    title(['Effective Area vs. Pan - ' cat]);
    xlim([min(sweepVar_deg) max(sweepVar_deg)]);
    legend('Location','bestoutside');
end

