function [P] = property_assignment(x, lb, ub, P, MVF_0)
global experiment
% Inputs:
% - x(1): M_f - M_s
% - x(2): M_f
% - x(3): A_s
% - x(4): A_f - A_s
% - x(5): C_M
% - x(6): C_A
% - x(7): H_max - H_min (proportional to initial)
% - x(8): k (proportional to initial)
% - x(9): alpha_M
% - x(10): alpha_A
% - x(11): rho_E
% - x(12): T_ambient
% - x(13): T_0
% - x(14): sigma_0
% - x(15): E_A
% - x(16): h
%alphas and sigma_crit are equal to zero in this problem

if nargin < 4
    MVF_0 = 1.0;
end

% Denormalizing
x = x.*(ub - lb) + lb;


%% SMA properties
% Young's Modulus for Austenite and Martensite 
% P.E_A = 8.0000e+10;
P.E_M = P.E_A*(1+x(15));

% Transformation temperatures (M:Martensite, A:
% Austenite), (s:start,f:final)
P.M_s = x(2) + x(1);
P.M_f = x(2);
P.A_s = x(3);
P.A_f = x(3) + x(4);

% Slopes of transformation boundarings into austenite (C_A) and
% martensite (C_M) at Calibration Stress 
P.C_M = x(5);
P.C_A = x(6);

% Maximum and minimum transformation strain
% P.H_min = x(10);
P.H_sat = x(7);
P.k = x(8);

% Smoothn hardening parameters 
% P.n1 = x(13);
% P.n2 = x(14);
% P.n3 = x(15);
% P.n4 = x(16);

% Coefficient of thermal expansion
P.alpha_M = x(9);
P.alpha_A = x(10);

%% Energy Coefficients
% Mass density
P.rho= 6450; %kg/m^3
% Specific Heat
P.c= 390;
% Heat convection coefficient
P.h = 1; % 1 is True and 0 is False
% electrical resistance
P.rho_E =  x(11);
% Ambient Temperature (Initial Temperature??)
P.T_ambient = x(12);
P.T_0 = x(13);
P.h = x(16);
%% Model Geometry
% d: Diameter of considered 1D model
P.d = 0.4e-3;

%% Initial conditions
% % initial stress
P.sigma_0 = x(14);
% % initial MVF and transformation strain;
try
    P = initial_conditions(P);
catch
    P.eps_0 = 0;
    P.MVF_0 = 0;
    P.eps_t_0 = 0;
end
    %% Algorithm parameters
% Algorithmic delta for modified smooth hardening function
P.delta=1e-5;
% Calibration Stress
P.sig_cal=200E6;
% Tolerance for change in MVF during implicit iteration
P.MVF_tolerance=1e-8;
try
    P.delay = ceil(x(17));
catch
    P.delay = 0;
end
end

