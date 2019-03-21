function output = plot_optimized(P, to_plot)
global experiment
if nargin < 2
    to_plot = ['temperature-strain'];
end
% Inputs:
% - x(1): E_M
% - x(2): E_A
% - x(3): M_s
% - x(4): M_s - M_f
% - x(5): A_s
% - x(6): A_f - A_s
% - x(7): C_M
% - x(8): C_A
% - x(9): H_min
% - x(10): H_max - H_min
% - x(11): k
% - x(12): n_1 
% - x(13): n_2
% - x(14): n_3
% - x(15): n_4
%alphas and sigma_crit are equal to zero in this problem

% Elastic Prediction Check
elastic_check = 'N';

% Integration Scheme
integration_scheme = 'I';

fields = fieldnames(experiment(1));
for i = 1:length(fields)
    field = char(fields(i));
    T = experiment(1).(field);
    eps = experiment(2).(field) + P.eps_0;
    sigma = experiment(3).(field) + P.sigma_0;
    
    disp(sigma(1))
    [eps_n, MVF, eps_t,E,MVF_r,eps_t_r ] = Full_Model_stress(T, sigma, P, ...
                                                              elastic_check, ...
                                                              integration_scheme);
    sigma = sigma / 1e6;
    if ismember('temperature-strain', to_plot)
        figure()
        box on
        hold on
        plot(T, eps, 'b', 'linewidth',2)
        plot(T, eps_n, '--r', 'linewidth',2)
        xlabel('Temperature (K)')
        ylabel('Strain (m/m)')
        title(strcat(num2str(round(mean(sigma),0)), ' MPa'))
        legend('Experiment','Calibrated')
    end
    if ismember('strain-stress', to_plot)
        figure()
        box on
        hold on
        plot(eps, sigma,  'b', 'linewidth',2)
        plot(eps_n, sigma, '--r', 'linewidth',2)
        xlabel('Strain (m/m)')
        ylabel('Stress (MPa)')
        legend('Experiment','Calibrated')
    end
    if ismember('temperature-MVF', to_plot)
        figure()
        box on
        hold on
        plot(MVF, 'k', 'linewidth',2)
        xlabel('Iteration')
        ylabel('matensitic Volume Fraction')
        legend('Experiment','Calibrated')
    end
    if ismember('stress-eps_t', to_plot)
        figure()
        box on
        hold on
        plot(eps_t, 'k', 'linewidth',2)
        xlabel('Iteration')
        ylabel('Transformation Strain (m/m)')
        legend('Experiment','Calibrated')
    end
    if ismember('temperature-stress', to_plot)
        figure()
        box on
        hold on
        plot(T, sigma, 'k', 'linewidth',2)
        xlabel('Temperature (K)')
        ylabel('Stress (MPa)')
        legend('Experiment','Calibrated')
    end
end

end
