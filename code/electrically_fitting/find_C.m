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
phase_list = [-25];

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

start = ceil(2*length(sigma)/3);
finish = length(sigma);
    
sigma = sigma(start:finish);
temperature = temperature(start:finish);

figure()
plot(temperature,sigma)

%% Set up the problem
MVF_0 = 0;    
x0 = [0, 0, 0, 0, 0, 0, 0, 0, ...
     0, 0, ...
     82e-2, 300., 300., ...
     100e6]; %, 0.5, 0];

A = [];
b = [];
Aeq = [];
beq = [];
lb = [-0.05, -0.05, -0.05, -0.05, -0.2, -0.2, -0.4, -0.4,...
     0., 0,...
     10e-3, 290., 290., ...
       0]; % 0, 0];

ub = [0.05, 0.05, 0.05, 0.05, 0.2, 0.2, 0.5, 0.5,...
     1e-5, 1e-5, ...
     500e-2, 330., 350., ...
       500e6]; %, 1, 0.06];


% Normalized x0
n_x0 = (x0 - lb)./(ub-lb);

% Normalized lower and upper bounds
n_lb = zeros(size(lb));
n_ub = ones(size(ub));

% Define function to be optimized
fun = @(x)cost(x, lb, ub, P, MVF_0);
nonlcon = [];
% options = optimoptions('fmincon','Display','iter','Algorithm','sqp', 'MaxFunEvals', 1000000, 'PlotFcns',{@optimplotx,...
%     @optimplotfval,@optimplotfirstorderopt});

% initial_error = cost(x, lb, ub, MVF_0);
options = optimoptions('ga','Display','iter','MaxGenerations',20, 'PlotFcn',{@gaplotbestf,...
    @gaplotbestindiv, @gaplotscores}, 'PopulationSize', 200, 'MaxStallGenerations', 50);

% x = fmincon(fun, n_x0, A, b, Aeq, beq, n_lb, n_ub, nonlcon, options);
x = ga(fun, length(n_x0), A, b, Aeq, beq, n_lb, n_ub, nonlcon, options);
P = property_assignment(x, lb, ub, P, MVF_0);
save('electric_calibrated','P')
disp(P)
plot_optimized(P)
phase_diagram(P, max(sigma)+P.sigma_0)


