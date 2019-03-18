function output = normalized_full_cost(x, lb, ub)
global initial_error
global initial_delta_eps
global experiment
% Inputs:
% - x(1): E_M
% - x(2): E_M - E_A
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
% - x(16): alpha_M
% - x(17): alpha_A
%alphas and sigma_crit are equal to zero in this problem

% % Upper and lower bounds used in normalization
% lb = [20e9, 10e9, ...
%      273.15 + 30, 0, 273.15 + 30, 0, 4E6, 4E6, ...
%      0.05, 0., 0, ...
%      0., 0., 0., 0.];
%  
% ub = [50e9, 40e9, ...
%      273.15 + 100, 50., 273.15 + 140, 50., 10E6, 10E6, ...
%      0.15, 0.05, 0.1e-6, ...
%      1., 1., 1., 1.];
% 
% Denormalizing
x = x.*(ub - lb) + lb;


% plot(T_50,eps_50)
% hold on
% plot(T_100,eps_100)
% plot(T_150,eps_150)

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

% Coefficient of thermal expansion
P.alpha = 0.;

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

% Elastic Prediction Check
elastic_check = 'N';

% Integration Scheme
integration_scheme = 'I';

try
    fields = fieldnames(experiment(1));
    colors = [0 0 1;
          0 0.5 0;
          1 0 0;
          0 0.75 0.75;
          0.75 0 0.75;
          0.75 0.75 0;
          0.25 0.25 0.25];
    figure(1);
    clf(1);
    hold on

    for i = 1:length(fields)
        field = char(fields(i));
        T = experiment(1).(field);
        eps = experiment(2).(field);
        sigma = 1e6 * experiment(3).(field);
        [eps_n, MVF,eps_t,E,MVF_r,eps_t_r ] = Full_Model_stress(T, sigma, P, ...
                                                                  elastic_check, ...
                                                                  integration_scheme);
        eps_n = eps_n - min(eps_n);

        plot(T, eps, 'color', colors(i,:), 'linewidth',2, 'DisplayName', field);
        plot(T, eps_n, '--','color', colors(i,:), 'linewidth',2)
        if i == 1
            rmse = sqrt(sum((eps-eps_n).^2)/numel(eps));
            delta_eps = abs((max(eps) - min(eps)) - (max(eps_n) - min(eps_n)));
        else
            rmse = rmse + sqrt(sum((eps-eps_n).^2)/numel(eps));
            delta_eps = delta_eps + abs((max(eps) - min(eps)) - (max(eps_n) - min(eps_n)));
        end
    end
    legend();
    delta_eps = delta_eps/length(fields);

    if (initial_error == 0)
        initial_error = rmse;
        initial_delta_eps = delta_eps;
    end
    output = rmse/initial_error + delta_eps/initial_delta_eps;

catch
    output = 100.;
end  
end
