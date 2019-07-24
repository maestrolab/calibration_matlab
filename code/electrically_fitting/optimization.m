close all; clc;
global initial_error
global initial_delta_eps
global experiment
global temperature_pseudo
global stress_pseudo
global strain_pseudo

initial_error = 0; 
initial_delta_eps = 0;

addpath('../electrically_driven/')
addpath('../phase_diagram/')

P = load('../pseudoelastic_fitting/pseudo_calibrated.mat');
P = P.P;
warning('off')
% Inputs:
% - x(1): M_s
% - x(2): M_s - M_f
% - x(3): A_s
% - x(4): A_f - A_s
% - x(5): C_M
% - x(6): C_A
% - x(7): H_max - H_min
% - x(8): k
% - x(9): alpha_M
% - x(10): alpha_A
% - x(11): rho_E
% - x(12): T_ambient
% - x(13): T_0
% - x(14): sigma_0
% - x(15): MVF_0
% - x(16): eps_t_0

%% Process experimental data
period_list = [25];
duty_list = [50];
phase_list = [25];

n_cycles = 3;

% Reading Excel File 
filename = '../../data/artificial_muscle/pseudoelastic_40C.xlsx';
temperature_pseudo = 273.15 + xlsread(filename,'E7:E2093');
stress_pseudo = 1e6*xlsread(filename,'I7:I2093');
strain_pseudo  = 1e-2*xlsread(filename,'L7:L2093');
temperature_pseudo = temperature_pseudo(1:2046);
stress_pseudo = stress_pseudo(1:2046);
strain_pseudo = strain_pseudo(1:2046);
% Filtering Data 
temperature_pseudo = smooth(temperature_pseudo, 0.1,'loess');
stress_pseudo = smooth(stress_pseudo, 0.1,'loess');
strain_pseudo = smooth(strain_pseudo, 0.1,'loess'); 
stress_pseudo = stress_pseudo - stress_pseudo(1,1);
strain_pseudo = strain_pseudo - strain_pseudo(1,1);
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

t = data(1).time - min(data(1).time);
eps = data(1).strain - data(1).strain(1,1);
sigma = data(1).stress - data(1).stress(1,1);
current = data(1).power;
experiment = data;

%% Set up the problem
MVF_0 = 0;    
x0 = [P.M_s-P.M_f, P.M_f, P.A_s, P.A_f-P.A_s, P.C_M, P.C_A, 0, 0, ...
     0, 0, ...
     82e-5, 300., 300., ...
     100e6, P.E_M/P.E_A-1, 100]; %, 0.5, 0];

A = [];
b = [];
Aeq = [];
beq = [];
lb = [5, 250, 280, 5, 4E6, 4E6, -0.4, -0.4,...
     0., 0,...
     10e-4, 290., 290., ...
       0, -.6, 10]; % 0, 0];

ub = [50, 300, 350, 50, 20E6, 20E6, 0.5, 0.5,...
     1.2e-5, 1.2e-5, ...
     500e-2, 330., 350., ...
       500e6, 0, 1000]; %, 1, 0.06];


% Normalized x0
n_x0 = (x0 - lb)./(ub-lb);

% Normalized lower and upper bounds
n_lb = zeros(size(lb));
n_ub = ones(size(ub));

% Define function to be optimized
initial_error = cost(x0, lb, ub, P, MVF_0);
fun = @(x)cost(x, lb, ub, P, MVF_0);
nonlcon = [];
% options = optimoptions('fmincon','Display','iter','Algorithm','sqp', 'MaxFunEvals', 1000000, 'PlotFcns',{@optimplotx,...
%     @optimplotfval,@optimplotfirstorderopt});
% x = fmincon(fun, n_x0, A, b, Aeq, beq, n_lb, n_ub, nonlcon, options);

options = optimoptions('ga','Display','iter','MaxGenerations',1000, 'PlotFcn',{@gaplotbestf,...
    @gaplotbestindiv, @gaplotscores}, 'PopulationSize', 200, 'MaxStallGenerations', 50);
options.InitialPopulationMatrix = repmat(x0, [5 1]);
x = ga(fun, length(n_x0), A, b, Aeq, beq, n_lb, n_ub, nonlcon, options);

P = property_assignment(x, lb, ub, P, MVF_0);
% save('electric_calibrated','P')
disp(P)
plot_optimized(P)
phase_diagram(P, max(sigma)+P.sigma_0)


