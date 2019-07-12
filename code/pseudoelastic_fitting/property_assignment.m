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
% - x(10): H_min
% - x(11): H_max - H_min
% - x(12): k
% - x(13): n_1 
% - x(14): n_2
% - x(15): n_3
% - x(16): n_4
%alphas and sigma_crit are equal to zero in this problem

if nargin < 4
    MVF_0 = 0.0;
end

% Denormalizing
x = x.*(ub - lb) + lb;

P.MVF_0 = MVF_0;
%% SMA properties
% Smoothn hardening parameters 
P.n1 = x(12);
P.n2 = x(13);
P.n3 = x(14);
P.n4 = x(15);

% Young's Modulus for Austenite and Martensite 
P.E_A = (1+x(1))*8.0000e+10;
P.E_M = (1+x(2))*3.5299e+10;

% Transformation temperatures (M:Martensite, A:
% Austenite), (s:start,f:final)


M_f = x(4);
M_s = (1+x(3))*M_f ;
A_s = (1+x(5))*M_f;
A_f = (1+x(6))*A_s;

% mss = .5*(1+2^(-P.n1)*(P.n1+1)+2^(-P.n2)*(P.n2-1))/(P.n1*2^(-P.n1)+P.n2*2^(-P.n2));
% msf = .5*(-1+2^(-P.n1)*(P.n1-1)+2^(-P.n2)*(P.n2+1))/(P.n1*2^(-P.n1)+P.n2*2^(-P.n2));
% mfs = .5*(-1+2^(-P.n1)*(P.n1+1)+2^(-P.n2)*(P.n2-1))/(P.n1*2^(-P.n1)+P.n2*2^(-P.n2));
% mff = .5*(1+2^(-P.n1)*(P.n1-1)+2^(-P.n2)*(P.n2+1))/(P.n1*2^(-P.n1)+P.n2*2^(-P.n2));
% 
% ass = .5*(1+2^(-P.n3)*(P.n3-1)+2^(-P.n4)*(P.n4+1))/(P.n3*2^(-P.n3)+P.n4*2^(-P.n4));
% asf = .5*(-1+2^(-P.n3)*(P.n3+1)+2^(-P.n4)*(P.n4-1))/(P.n3*2^(-P.n3)+P.n4*2^(-P.n4));
% afs = .5*(-1+2^(-P.n3)*(P.n3-1)+2^(-P.n4)*(P.n4+1))/(P.n3*2^(-P.n3)+P.n4*2^(-P.n4));
% aff = .5*(1+2^(-P.n3)*(P.n3+1)+2^(-P.n4)*(P.n4-1))/(P.n3*2^(-P.n3)+P.n4*2^(-P.n4));

% P.M_s = mss*M_s + msf*M_f;
% P.M_f = mfs*M_s + mff*M_f;
% P.A_s = ass*A_s + asf*A_f;
% P.A_f = afs*A_s + aff*A_f;
P.M_s = M_s;
P.M_f = M_f;
P.A_s = A_s;
P.A_f = A_f;
% Slopes of transformation boundarings into austenite (C_A) and
% martensite (C_M) at Calibration Stress 
P.C_M = x(7);
P.C_A = x(8);

% Maximum and minimum transformation strain
P.sig_crit = 0;
if P.sig_crit > 0
    P.H_min = 0;
else
    P.H_min = x(9);
end
P.H_sat = x(9) + x(10);
P.k = x(11);

% Coefficient of thermal expansion
P.alpha_A = 0.;
P.alpha_M = 0.;

% Smoothn hardening parameters 
P.n1 = x(12);
P.n2 = x(13);
P.n3 = x(14);
P.n4 = x(15);

%% Algorithm parameters
% Algorithmic delta for modified smooth hardening function
P.delta=1e-5;
% Calibration Stress
P.sig_cal=200E6;
% Tolerance for change in MVF during implicit iteration
P.MVF_tolerance=1e-8;
end

