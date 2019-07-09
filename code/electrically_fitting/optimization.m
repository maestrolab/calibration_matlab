close all; clc;
global initial_error
global initial_delta_eps
global experiment
initial_error = 0;
initial_delta_eps = 0;

addpath('../electrically_driven/')
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
% - x(19): rho_E
% - x(20): T_ambient

%% Process experimental data
period_list = [25];
duty_list = [50];
phase_list = [0];

n_cycles = 5;

n_periods = length(period_list);
n_duty = length(duty_list);
n_phase = length(phase_list);
n_combinations = n_periods*n_duty*n_phase;
DOE_matrix = zeros(n_combinations, 5);

% Extracting data
directory = '../../data/artificial_muscle_electric/';
                  
for i = 1:n_periods
   period = period_list(i);
   [DOE_matrix((i-1)*n_duty*n_phase+1 : i*n_duty*n_phase,:),temp] = ...
       retrieve_data(period, duty_list, phase_list, n_cycles, ...
       directory);
   data = temp;
end

t = data(1).time;
eps = data(1).strain;
sigma = data(1).stress;
current = data(1).power;
experiment = data;

%% Set up the problem
MVF_0 = 0;    
x0 = [91.01E9, 91.01E9 - 44.93E9, ...
     273.15 + 32.38, 62.38 - 51.69, 40, 83.49 - 70.96, 8.15e6, 7.64E6,...
     0, 0.03878, 0.06272 - 0.03878, 0.00359e-6,  ...
     0.2, 0.2, 0.2, 0.3, ...
     1e-6, 1e-6, ...
     82e-6, 300., 300.];

A = [];
b = [];
Aeq = [];
beq = [];
lb = [50e9, 0e9, ...
     273.15 - 10, 2, 0, 0, 4E6, 4E6, ...
     0, 0.01, 0., 0.0001e-6,  ...
     0., 0., 0., 0., ...
     0., 0, ...
     10e-6, 273.15 + 10., 273.];

ub = [140e9, 140e9, ...
     273.15 + 50, 50., 100, 50., 20E6, 20E6, ...
     300E6, 0.06, 0.06, 0.01e-6, ...
     1., 1., 1., 1., ...
     1e-5, 1e-5, ...
     500e-5, 273.15 + 30., 350.];


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
P = property_assignment(x, lb, ub, MVF_0);
disp(P)
plot_optimized(P)
phase_diagram(P, max(sigma))


