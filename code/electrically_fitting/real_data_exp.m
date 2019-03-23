% Initializing environment
clear all; close all; clc

addpath('../electrically_driven/')
addpath('../phase_diagram/')
%% Process experimental data
period_list = [21];
duty_list = [50];
phase_list = [25];

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

%% SMA properties
% Young's Modulus for Austenite and Martensite 
P.E_A = 3.7427e+10;
P.E_M = 8.8888e+10;

% Transformation temperatures (M:Martensite, A:
% Austenite), (s:start,f:final)
P.M_s = 300.;
P.M_f = 290.;
P.A_s = 314.6427;
P.A_f = 325.0014;

% Slopes of transformation boundarings into austenite (C_A) and
% martensite (C_M) at Calibration Stress 
P.C_A = 5.1986e+06;
P.C_M = 5.9498e+06;

% Maximum and minimum transformation strain
P.sig_crit = 0;
P.H_min = 0.055;
P.H_sat = 0.0550;
P.k = 4.6849e-09;

% Smoothn hardening parameters 
P.n1 = 0.1919; %0.618;
P.n2 = 0.1823; %0.313;
P.n3 = 0.1623; %0.759;
P.n4 = 0.2188; %0.358;

% Coefficient of thermal expansion
P.alpha_A = 0; 
P.alpha_M = 0;

%% Energy Coefficients
% Mass density
P.rho= 6500; %kg/m^3
% Specific Heat
P.c= 837.36;
% Heat convection coefficient
P.h = 1; % 1 is True and 0 is False
% electrical resistance
P.rho_E =  1./1.3494e+03;
% Ambient Temperature (Initial Temperature??)
P.T_ambient = 303.15;

%% Model Geometry
% d: Diameter of considered 1D model
P.d = 0.4e-3;

%% Initial conditions
% initial stress
P.sigma_0 = 0;
% initial MVF
P.MVF_0 = .0;
% initial transformation strain
P.eps_t_0 = 0;

%% Algorithm parameters
% Algorithmic delta for modified smooth hardening function
P.delta=1e-5;
% Calibration Stress
P.sig_cal=200E6;
% Tolerance for change in MVF during implicit iteration
P.MVF_tolerance=1e-8;

%% Run
% Only positive stress?
stress_flag = true;

elastic_check = 'N';

[sigma_n,MVF,T,eps_t,E,MVF_r,eps_t_r, h_convection, pi_t, eps ] = Full_Model_TC( t, eps, current, P, elastic_check, stress_flag);



