close all; clc;
global initial_error
global initial_delta_eps
global experiment
initial_error = 0;
initial_delta_eps = 0;

addpath('../main/')
addpath('../phase_diagram/')
% Inputs:
% - x(1): E_M
% - x(2): E_A
% - x(3): M_s
% - x(4): M_s - M_f
% - x(5): A_s
% - x(6): A_f - A_s
% - x(7): C_M
% - x(8): C_A
% - x(9): sigma_crit
% - x(10): H_min
% - x(11): H_max - H_min
% - x(12): k
% - x(13): n_1 
% - x(14): n_2
% - x(15): n_3
% - x(16): n_4
% - x(17): alpha_M
% - x(18): alpha_A
% - x(19): eps_0
%alphas and sigma_crit are equal to zero in this problem
% Initial guess (parameters calibrated from experiments)

% x0 = [37e9, 53e9, ...
%      273.15 + 55.74, 55.74 - 35.57, 273.15 + 72.93, 87.77 - 72.93, 4.54E6, 8.64E6, ...
%      0.1, 0.12, 0.0001, ...
%      .5, .5, .5, .5];
% x0 = [60e9, 60e9, ...
%      374.2813, 374.2813 - 290.7571, 318.9352,  397.9732 - 318.9352, 7.8E6, 7.8E6, ...
%      0.0952, -0.001, 0.0001, ...
%      .2215, .2059, .2040, .2856];


filepath = '../../data/test/';
stress_in_MPa = true;
reorder = false;
MVF_0 = 0;
to_plot = ['temperature-strain', 'strain-stress', 'temperature-MVF', 'stress-eps_t'];
experiment = process_data(filepath, stress_in_MPa, reorder);
    
x0 = [91.01E9, 91.01E9 - 44.93E9, ...
     273.15 + 62.38, 62.38 - 51.69, 273.15 + 70.96, 83.49 - 70.96, 8.15e6, 7.64E6,...
     0, 0.03878, 0.06272 - 0.03878, 0.00359e-6,  ...
     0.2, 0.2, 0.2, 0.3, ...
     1e-6, 1e-6, ...
     0.0];

A = [];
b = [];
Aeq = [];
beq = [];
lb = [70e9, 0e9, ...
     273.15 + 50, 0, 273.15 + 50, 0, 4E6, 4E6, ...
     0, 0.01, 0., 0.0001e-6,  ...
     0., 0., 0., 0., ...
     0., 0, ...
     0.0];

ub = [140e9, 140e9, ...
     273.15 + 100, 75., 273.15 + 100, 80., 16E6, 16E6, ...
     300E6, 0.06, 0.06, 0.01e-6, ...
     1., 1., 1., 1., ...
     1e-5, 1e-5, ...
     0.001];


% Normalized x0
n_x0 = (x0 - lb)./(ub-lb);

% Normalized lower and upper bounds
n_lb = zeros(size(lb));
n_ub = ones(size(ub));

% Define function to be optimized
fun = @(x)cost(x, lb, ub, MVF_0);
nonlcon = [];
options = optimoptions('fmincon','Display','iter','Algorithm','sqp', 'MaxFunEvals', 1000000, 'PlotFcns',{@optimplotx,...
    @optimplotfval,@optimplotfirstorderopt});
x = fmincon(fun, n_x0, A, b, Aeq, beq, n_lb, n_ub, nonlcon, options);
% opts = gaoptimset(...
%     'PopulationSize', 20, ...
%     'Generations', 50, ...
%     'Display', 'iter', ...
%     'EliteCount', 2);
% x = ga(fun, 15, A, b, Aeq, beq, lb, ub, nonlcon, opts);
P = property_assignment(x, lb, ub, MVF_0);
disp(P)
plot_optimized(P, to_plot)
phase_diagram(P)


