function [P] = property_assignment(x, lb, ub, MVF_0)
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
%alphas and sigma_crit are equal to zero in this problem

if nargin < 4
    MVF_0 = 1.0;
end

% 
T_0 = 0;
fields = fieldnames(experiment(1));
for i=1:length(fields)
    field = char(fields(i));
    if experiment(1).(field)(1) > T_0
        T_0 = experiment(1).(field)(1);
    end
end

% Denormalizing
x = x.*(ub - lb) + lb;


%% SMA properties
% Young's Modulus for Austenite and Martensite 
P.E_A = x(1);
P.E_M = x(1) - x(2);

% Transformation temperatures (M:Martensite, A:
% Austenite), (s:start,f:final)
P.M_s = x(3);
P.M_f = x(3) - x(4);
P.A_s = P.M_f + x(5);
P.A_f = P.A_s + x(6);

% Slopes of transformation boundarings into austenite (C_A) and
% martensite (C_M) at Calibration Stress 
P.C_M = x(7);
P.C_A = x(8);

% Maximum and minimum transformation strain
P.sig_crit = x(9);
if P.sig_crit > 0
    P.H_min = 0;
else
    P.H_min = x(10);
end
P.H_sat = x(10) + x(11);
P.k = x(12);

% Smoothn hardening parameters 
P.n1 = x(13);
P.n2 = x(14);
P.n3 = x(15);
P.n4 = x(16);

% Coefficient of thermal expansion
P.alpha_M = x(17);
P.alpha_A = x(18);

%% Energy Coefficients
% Mass density
P.rho= 6500; %kg/m^3
% Specific Heat
P.c= 837.36;
% Heat convection coefficient
P.h = 1; % 1 is True and 0 is False
% electrical resistance
P.rho_E =  x(19);
% Ambient Temperature (Initial Temperature??)
P.T_ambient = x(20);

%% Model Geometry
% d: Diameter of considered 1D model
P.d = 0.4e-3;

%% Initial conditions
% initial stress
P.sigma_0 = 0;
% initial MVF
P.MVF_0 = MVF_0;
% initial transformation strain
P.eps_t_0 = 0;

%% Algorithm parameters
% Algorithmic delta for modified smooth hardening function
P.delta=1e-5;
% Calibration Stress
P.sig_cal=200E6;
% Tolerance for change in MVF during implicit iteration
P.MVF_tolerance=1e-8;
end

