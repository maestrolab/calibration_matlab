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

% Positive stress?
stress_flag = true;

fields = fieldnames(experiment(1));
for i = 1:length(fields)
    field = char(fields(i));
    t = experiment(1).time;
    eps = experiment(1).strain;
    sigma = experiment(1).stress;
    current = experiment(1).power;
    
    [sigma_n,MVF,T,eps_t, ...
        E,MVF_r eps_t_r, ...
        h_convection, pi_t, eps ] = Full_Model_TC( t, eps, current, P, ...
                                                   elastic_check, ...
                                                   stress_flag);
    sigma = sigma / 1e6;
    sigman = sigma_n / 1e6;
    plot(eps, sigma, 'b', 'linewidth',2, 'DisplayName', field);
    plot(eps, sigma_n, 'r', 'linewidth',2)
end

end
