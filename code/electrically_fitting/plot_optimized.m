function output = plot_optimized(P, experiment, pseudo_experiment, to_plot)

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

% Plot pseudoelastic
error = pseudoelastic(P, pseudo_experiment, true);


% Elastic Prediction Check
elastic_check = 'N';

% Positive stress?
stress_flag = false;

for i = 1:length(experiment)
    t = experiment(1).time - min(experiment(1).time);
    eps = experiment(1).strain - experiment(1).strain(1,1)+ P.eps_0;
    sigma = experiment(1).stress - experiment(1).stress(1,1) + P.sigma_0;
    if P.delay>=0
        current = [experiment(1).power(1+P.delay:end); experiment(1).power(1:P.delay)];
    else
        current = [experiment(1).power(end+P.delay+1:end); experiment(1).power(1:end+P.delay)];
    end
    % current = cat(1,current(40:728),current(1:39));
    [sigma_n,MVF,T,eps_t, ...
        E,MVF_r eps_t_r, ...
        h_convection, pi_t, eps_n ] = Full_Model_TC( t, eps, current, P, ...
                                                   elastic_check, ...
                                                   stress_flag);
    
    sigma = sigma / 1e6;
    sigma_n = sigma_n / 1e6;
    
    start = ceil(2*length(sigma)/3);
    finish = length(sigma);
    
    figure()
    hold on
    box on
    plot(eps(start:finish), sigma(start:finish), 'b', 'linewidth',2, 'DisplayName', 'Experimental');
    plot(eps_n(start:finish), sigma_n(start:finish), 'r', 'linewidth',2, 'DisplayName', 'Model');
    legend('Location','best')
    xlabel('Strain (m/m)')
    ylabel('Stress (MPa)')
    
    figure()
    hold on
    box on
    plot(t(start:finish), MVF(start:finish), 'b', 'linewidth',2, 'DisplayName', 'MVF');
    plot(t(start:finish), eps_t(start:finish), 'r', 'linewidth',2, 'DisplayName', 'eps_t');
    legend('Location','best')

    figure()
    hold on
    box on
    plot(t(start:finish), sigma(start:finish), 'k', 'linewidth',2, 'DisplayName', 'Experiment');
    plot(t(start:finish), sigma_n(start:finish), '--k', 'linewidth',2, 'DisplayName', 'Model');
    legend('Location','best')

    figure()
    hold on
    box on
    yyaxis left
    plot(t(start:finish), eps(start:finish), 'b', 'linewidth',2, 'DisplayName', 'Strain');
    ylim([min(eps(start:finish)) max(eps(start:finish))])
    yyaxis right
    plot(t(start:finish), T(start:finish), 'r', 'linewidth',2, 'DisplayName', 'Temperature');
    ylim([min(T(start:finish)) max(T(start:finish))])
    legend('Location','best')

        figure()
    hold on
    box on
    plot(t(start:finish), current(start:finish), 'k', 'linewidth',2, 'DisplayName', 'Current');
    legend('Location','best')
    
    figure()
    hold on
    plot(T(start:finish), sigma(start:finish), 'k', 'linewidth',2, 'DisplayName', 'Experimental');
    plot(T(start:finish), sigma_n(start:finish), '--k', 'linewidth',2, 'DisplayName', 'Model');
end

end
