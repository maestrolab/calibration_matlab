function output = plot_optimized(P, to_plot)
global experiment
global temperature_pseudo
global stress_pseudo
global strain_pseudo
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
P.eps_0 = strain_pseudo(1,1);
P.eps_t_0 = 0;
% Elastic Prediction Check
elastic_check = 'N';

% Only positive stress?
stress_flag = false;

integration_scheme = 'I';

[eps,MVF,eps_t,E,MVF_r,eps_t_r ] = Full_Model_stress(temperature_pseudo, stress_pseudo, P, elastic_check, integration_scheme );
 figure(4);
clf(4);
box on 
hold on
plot(MVF,'r','LineWidth',1.5)
plot(eps_t,'b','LineWidth',1.5)
end
