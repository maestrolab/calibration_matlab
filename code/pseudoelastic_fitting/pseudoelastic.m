function [error] = pseudoelastic(P, to_plot)
global temperature_pseudo
global stress_pseudo
global strain_pseudo
addpath('../temperature_driven/')


P.eps_0 = strain_pseudo(1,1);
P.eps_t_0 = 0;
% Elastic Prediction Check
elastic_check = 'N';

% Only positive stress?
stress_flag = false;

integration_scheme = 'I';

[eps,MVF,eps_t,E,MVF_r,eps_t_r ] = Full_Model_stress(temperature_pseudo, stress_pseudo, P, elastic_check, integration_scheme );
error = real(sqrt(sum((eps-strain_pseudo).^2)/numel(eps)));
if to_plot
    figure(1);
    clf(1);
    box on 
    hold on
    plot(eps,stress_pseudo,'r','LineWidth',1.5)
    plot(strain_pseudo,stress_pseudo,'b','LineWidth',1.5)
    xlabel('Strain')
    ylabel('Stress (MPa)')
end
end