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
% - x(19): eps_0
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


% INPUT:
% MATERIAL PARAMETERS (Structure: P)
% Young's Modulus for Austenite and Martensite 
P.E_M = x(1);
P.E_A = x(1) - x(2);
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


% Coefficient of thermal expansion
P.alpha = 0.;

% Smoothn hardening parameters 
% NOTE: smoothness parameters must be 1 for explicit integration scheme
P.n1 = x(13);
P.n2 = x(14);
P.n3 = x(15);
P.n4 = x(16);

% Coefficient of thermal expansion
P.alpha_M = x(17);
P.alpha_A = x(18);

% Algorithmic delta for modified smooth hardening function
P.delta=1e-5;

% Calibration Stress
P.sig_cal=200E6;

% Initial MVF
P.MVF_0 = MVF_0;

% Tolerance for change in MVF during implicit iteration
P.MVF_tolerance=1e-8;

% Guessing an initial stress or strain
if isnan(x(19))
    P.eps_0 = 0;
else
    P.eps_0 = x(19);
end
P = stable_initial_conditions(P);
% P.sigma_0 = 0;
end

