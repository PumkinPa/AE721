function plotGIFOV(eps_i_deg, GIFOV_cell, phi_vec, target_name)
    % INPUTS:
    %   eps_i_deg  : pixel angles in degrees [vector]
    %   GIFOV_cell : cell array, one GIFOV vector per phi
    %   phi_vec    : impact angles [deg]
    %   target_name: string for title

    markers = {'-o', '--s', ':^'};
    figure; hold on;
    for k = 1:length(phi_vec)
        plot(eps_i_deg, GIFOV_cell{k}, markers{k}, ...
             'MarkerIndices', 1:10:length(eps_i_deg), ...
             'Color', 'k', ...
             'DisplayName', ['\phi = ' num2str(phi_vec(k)) '°']);
    end
    xlabel('\epsilon_i [deg]');
    ylabel('GIFOV_i [m]');
    title(['GIFOV vs Off-Axis Angle — ' target_name]);
    legend('Location','best');
    grid on;
end