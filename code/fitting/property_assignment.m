function [P] = property_assignment(x, lb, ub)
% Inputs:
% - x(1): E_M
% - x(2): E_M - E_A
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
% - x(16): alpha_M
% - x(17): alpha_A
%alphas and sigma_crit are equal to zero in this problem

% 
% Denormalizing
x = x.*(ub - lb) + lb;


% plot(T_50,eps_50)
% hold on
% plot(T_100,eps_100)
% plot(T_150,eps_150)

% INPUT:
% MATERIAL PARAMETERS (Structure: P)
% Young's Modulus for Austenite and Martensite 
P.E_M = x(1);
P.E_A = x(1) - x(2);
% Transformation temperatures (M:Martensite, A:
% Austenite), (s:start,f:final)
P.M_s = x(3);
P.M_f = x(3) - x(4);
P.A_s = x(5);
P.A_f = x(6) + x(5);

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

% Tolerance for change in MVF during implicit iteration
P.MVF_tolerance=1e-8;

% Guessing an initial stress or strain
if isnan(x(19))
    P.eps_0 = 0;
else
    P.eps_0 = 0;
end
error = 999;
iter_max = 1000;
iter = 1;
P.sigma_0 = 0;
while (error > 1e-6 && iter < iter_max)
    sigma_prev = P.sigma_0;
    H_cur = H_cursolver(P.sigma_0,P.sig_crit,P.k,P.H_min,P.H_sat);
    P.sigma_0 = P.E_M*(P.eps_0-H_cur);
    error = abs(P.sigma_0 - sigma_prev);
%     disp(P.sigma_0)
%     disp(sigma_prev)
    iter = iter + 1;
end
if iter >= iter_max
    P.eps_0 = 0;
    P.sigma_0 = 0;
end
end

