function [P] = property_assignment(x, lb, ub, P, MVF_0)
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
% - x(21): T_0
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
P.M_s = (1+x(1))*P.M_s +x(2)*P.M_f;
P.M_f = (1+x(2))*P.M_f;
P.A_s = (1+x(3))*P.A_s;
P.A_f = (1+x(4))*P.A_f +x(3)*P.A_s;

% Slopes of transformation boundarings into austenite (C_A) and
% martensite (C_M) at Calibration Stress 
P.C_M = (1+x(5))*P.C_M;
P.C_A = (1+x(6))*P.C_A;

% Maximum and minimum transformation strain
% P.H_min = x(10);

P.H_sat = (1+x(7))*P.H_sat;
P.k = (1+x(8))*P.k;

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
P.rho= 6500; %kg/m^3
% Specific Heat
P.c= 837.36;
% Heat convection coefficient
P.h = 1; % 1 is True and 0 is False
% electrical resistance
P.rho_E =  x(11);
% Ambient Temperature (Initial Temperature??)
P.T_ambient = x(12);
P.T_0 = x(13);

%% Model Geometry
% d: Diameter of considered 1D model
P.d = 0.4e-3;

%% Initial conditions
% % initial stress
P.sigma_0 = x(14);
% % initial MVF and transformation strain;
P = initial_conditions(P);
%% Algorithm parameters
% Algorithmic delta for modified smooth hardening function
P.delta=1e-5;
% Calibration Stress
P.sig_cal=200E6;
% Tolerance for change in MVF during implicit iteration
P.MVF_tolerance=1e-8;
end

