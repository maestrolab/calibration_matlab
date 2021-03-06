%--------------------------------------------------------------------------
%
% 1D SMA TAMU MODEL, EXPLICIT AND IMPLICIT IMPLEMENTATION 
%
% SUPLEMENTAL CODE FOR:
% Analysis and Design of Shape Memory Alloy Morphing Structures
% - Dimitris Lagoudas, Edwin Peraza Hernandez, Darren Hartl
%
% XXXXXXXXX ADD REFERENTIAL INFORMATION HERE XXXXXXXX
%
%
% APPLICATIONS:
% - 1D uniaxial loading of an SMA component
%
% CONDITIONS:
% - Initial fully austenitic state
%
%
% Authors: Cullen Nauck, Edwin Peraza Hernandez
% Department of Aerospace Engineering, Texas A&M University
% 3141 TAMU, College Station, TX 77843-3141
%
%--------------------------------------------------------------------------

% Initializing environment
clear all; close all; clc

%--------------------------------------------------------------------------
% INPUTS
%--------------------------------------------------------------------------

% Maximum Number of increments n per loading step
n = 300; 

% INPUT:
% Temperature and strain at the start and at the ends of each loading step
% Linear increments strain and temperature loading step assumed
T_inp = [55+273.15; 55+273.15; 55+273.15];

sigma_inp = [0; 720e6; 0];


% MATERIAL PARAMETERS (Structure: P)
% Young's Modulus for Austenite and Martensite 
P.E_A = 55E9;
P.E_M = 46E9;
% Transformation temperatures (M:Martensite, A:
% Austenite), (s:start,f:final)
P.M_s = -28+273.15;
P.M_f = -43+273.15;
P.A_s = -3+273.15;
P.A_f = 7+273.15;

% Slopes of transformation boundarings into austenite (C_A) and
% martensite (C_M) at Calibration Stress 
P.C_A = 7.4E6;
P.C_M = 7.4e6;

% Maximum and minimum transformation strain
P.H_min = 0.056;
P.H_sat = 0.056;

P.k = 0;
P.sig_crit = 0;

% Coefficient of thermal expansion
P.alpha_A = 10E-6;
P.alpha_M = 10E-6;

% Smoothn hardening parameters 
% NOTE: smoothness parameters must be 1 for explicit integration scheme
P.n1 = 1;
P.n2 = 1;
P.n3 = 1;
P.n4 = 1;

% Algorithmic delta for modified smooth hardening function
P.delta=1e-5;

% Calibration Stress
P.sig_cal=200E6;

% Tolerance for change in MVF during implicit iteration
P.MVF_tolerance=1e-8;

% Generate strain and temperature states at each increment
% T: Temperature
for i = 1:(size(T_inp,1)-1)
    if i == 1
        T = linspace(T_inp(i), T_inp(i+1), n)';
    else     
        T = [T; linspace(T_inp(i), T_inp(i+1),n)'];
    end
end

% eps: Strain
for i = 1:(size(sigma_inp,1)-1)
    if i == 1
        sigma = linspace(sigma_inp(i), sigma_inp(i+1), n)';
    else     
        sigma = [sigma; linspace(sigma_inp(i), sigma_inp(i+1),n)'];
    end
end

% Elastic Prediction Check
prompt = {'Will the Elastic Prediction Check be Transformation Surface Rate-informed or not (Y/N)?'};
dlg_title = '1D SMA Model Elastic Prediction Check';
num_lines = 1;
defaultans = {'N','hsv'};
elastic_check = inputdlg(prompt,dlg_title,num_lines,defaultans);

% Integration Scheme
prompt2 = {'Integration Scheme (Implicit/Explicit, I/E):'};
dlg_title = '1D SMA Model Integration Scheme';
num_lines = 1;
defaultans2 = {'I','hsv'};
integration_scheme = inputdlg(prompt2,dlg_title,num_lines,defaultans2);

[eps,MVF,eps_t,E,MVF_r,eps_t_r ] = Full_Model_stress( T, sigma, P, elastic_check, integration_scheme );

figure()
box on 
plot(eps,sigma/1E6,'b','LineWidth',1.5)
xlabel('Strain')
ylabel('Stress (MPa)')
title('One D SMA Models')
set(gca,'FontName','Times New Roman','fontsize', 20,'linewidth',1.15)
set(gca,'XMinorTick','on','YMinorTick','on')
set(gca,'ticklength',3*get(gca,'ticklength'))
