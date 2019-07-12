close all; clc;
global initial_error
global initial_delta_eps
global experiment
global temperature_pseudo
global stress_pseudo
global strain_pseudo
initial_error = 0;
initial_delta_eps = 0;
addpath('../temperature_driven/')

warning('off')
% Inputs:
% - x(1): E_M
% - x(2): E_A
% - x(3): M_s
% - x(4): M_s - M_f
% - x(5): A_s
% - x(6): A_f - A_s
% - x(7): C_M
% - x(8): C_A
% - x(10): H_min
% - x(11): H_max - H_min
% - x(12): k
% - x(13): n_1 
% - x(14): n_2
% - x(15): n_3
% - x(16): n_4
%% Process experimental data
n_cycles = 5;

% Reading Excel File 
filename = '../../data/artificial_muscle/pseudoelastic_40C.xlsx';
temperature_pseudo = 273.15 + xlsread(filename,'E7:E2093');
stress_pseudo = 1e6*xlsread(filename,'I7:I2093');
strain_pseudo  = 1e-2*xlsread(filename,'L7:L2093');
temperature_pseudo = temperature_pseudo(1:2052);
stress_pseudo = stress_pseudo(1:2052);
strain_pseudo = strain_pseudo(1:2052);

% Filtering Data 
temperature_pseudo = smooth(temperature_pseudo, 0.1,'loess');
stress_pseudo = smooth(stress_pseudo, 0.1,'loess');
strain_pseudo = smooth(strain_pseudo, 0.1,'loess'); 
stress_pseudo = stress_pseudo - stress_pseudo(1,1);
strain_pseudo = strain_pseudo - strain_pseudo(1,1);


%% Set up the problem
MVF_0 = 0;    
x0 = [0, 0, 0.025,  300, .05,.1, ...
      8.15e6, 7.64E6,...
      0, 0.03, 0.00359e-6,  ...
      0.8, 0.8, 0.8, 0.8];

A = [];
b = [];
Aeq = [];
beq = [];
lb = [-.1, -.1, 0, 260, 0, 0,...
     4E6, 4E6, ...
     0, 0.02, 0.0001e-6,  ...
     0.01, 0.01, 0.01, 0.01];

ub = [ .1,  .1,  .04, 310, .2,  .04,...
     20E6, 20E6, ...
     0.03, 0.06, 0.01e-6, ...
     1., 1., 1., 1.];


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

% initial_error = cost(x, lb, ub, MVF_0);
% options = optimoptions('ga','Display','iter','MaxGenerations',100, 'PlotFcn',{@gaplotbestf,...
%     @gaplotbestindiv, @gaplotscores}, 'PopulationSize', 100, 'MaxStallGenerations', 50);

x = fmincon(fun, n_x0, A, b, Aeq, beq, n_lb, n_ub, nonlcon, options);
% x = ga(fun, length(n_x0), A, b, Aeq, beq, n_lb, n_ub, nonlcon, options);
P = property_assignment(x, lb, ub, true);
disp(P)
plot_optimized(P)
figure(3)
phase_diagram(P, max(stress_pseudo))
plot(temperature_pseudo, stress_pseudo/1e6, 'k')
save('pseudo_calibrated','P')


