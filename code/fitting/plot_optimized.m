function output = normalized_full_plot_optimized(x, lb, ub)
global experiment
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

% Denormalizing
x = x.*(ub - lb) + lb;

%Read data from experiments. For constant stress sigma:
% - data_sigma(1): Temperature (in Celsius)
% - data_sigma(2): Strain
% - data_sigma(3): Stress

% INPUT:
% MATERIAL PARAMETERS (Structure: P)
% Young's Modulus for Austenite and Martensite 
P.E_M = x(1);
P.E_A = x(1) - x(2);
% Transformation temperatures (M:Martensite, A:
% Austenite), (s:start,f:final)
P.M_s = x(3);
P.M_f = x(3) - x(4);
P.A_s = x(5);
P.A_f = x(6) + x(5);

% Slopes of transformation boundarings into austenite (C_A) and
% martensite (C_M) at Calibration Stress 
P.C_M = x(7);
P.C_A = x(8);

% Maximum and minimum transformation strain
P.H_min = x(9);
P.H_sat = x(9) + x(10);

P.k = x(11);
P.sig_crit = 0;

% Smoothn hardening parameters 
% NOTE: smoothness parameters must be 1 for explicit integration scheme
P.n1 = x(12);
P.n2 = x(13);
P.n3 = x(14);
P.n4 = x(15);

% Coefficient of thermal expansion
P.alpha_M = x(16);
P.alpha_A = x(17);

% Algorithmic delta for modified smooth hardening function
P.delta=1e-5;

% Calibration Stress
P.sig_cal=200E6;

% Tolerance for change in MVF during implicit iteration
P.MVF_tolerance=1e-8;

disp(P)

% Elastic Prediction Check
elastic_check = 'N';

% Integration Scheme
integration_scheme = 'I';

fields = fieldnames(experiment(1));
for i = 1:length(fields)
    field = char(fields(i));
    T = experiment(1).(field);
    sigma = 1e6 *experiment(3).(field);
    [eps_n, MVF,eps_t,E,MVF_r,eps_t_r ] = Full_Model_stress(T, sigma, P, ...
                                                              elastic_check, ...
                                                              integration_scheme);
    eps_num.(field) = eps_n - min(eps_n);
end
% Plotting

for i = 1:length(fields)
    figure()
	box on
    hold on
    field = char(fields(i));
    T = experiment(1).(field);
    eps = experiment(2).(field);
    sigma = experiment(3).(field);
    eps_n = eps_num.(field);
    plot(T, eps, 'b', 'linewidth',2)
    plot(T, eps_n, '--r', 'linewidth',2)
    xlabel('Temperature (K)')
    ylabel('Strain (m/m)')
    title(strcat(num2str(sigma(1)), ' MPa'))
    legend('Experiment','Calibrated')
end

end
