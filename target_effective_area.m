function [targets, sweepVar_deg, sweepLabel] = target_effective_area(sweepType, fixedAngle_deg)
%
%   MODEL
%   A_eff(impact, approach) = A_top   * |cos(impact)|
%                    + A_front * |sin(impact) * cos(approach)|
%                    + A_side  * |sin(impact) * sin(approach)|
%
if nargin < 1 || isempty(sweepType)
    fprintf('Pan sweep type:\n');
    fprintf('  1 = Sweep APPROACH ANGLE (nose <-> side) at a fixed IMPACT ANGLE\n');
    fprintf('  2 = Sweep IMPACT ANGLE (top-down <-> level) at a fixed APPROACH ANGLE\n');
    sweepType = input('Enter 1 or 2 [default 1]: ');
    if isempty(sweepType)
        sweepType = 1;
    end
end

if sweepType == 1
    if nargin < 2 || isempty(fixedAngle_deg)
        fixedAngle_deg = input('Enter the fixed impact angle in deg (0=level, 90=straight down) [default 45]: ');
        if isempty(fixedAngle_deg)
            fixedAngle_deg = 45;
        end
    end
    approach_deg = 0:1:90; % 0 = nose-on, 90 = broadside
    impact_deg = fixedAngle_deg * ones(size(approach_deg));
    sweepVar_deg = approach_deg;
    sweepLabel = sprintf('Approach Angle (deg)  [impact angle fixed at %g deg]', fixedAngle_deg);
else
    if nargin < 2 || isempty(fixedAngle_deg)
        fixedAngle_deg = input('Enter the fixed approach angle in deg (0=nose-on, 90=broadside) [default 0]: ');
        if isempty(fixedAngle_deg)
            fixedAngle_deg = 0;
        end
    end
    impact_deg = 0:1:90; % 0 = level, 90 = straight down
    approach_deg = fixedAngle_deg * ones(size(impact_deg));
    sweepVar_deg = impact_deg;
    sweepLabel = sprintf('Impact Angle (deg)  [approach angle fixed at %g deg]', fixedAngle_deg);
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

end
