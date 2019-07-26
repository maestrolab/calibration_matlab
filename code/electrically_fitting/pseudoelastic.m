function [error] = pseudoelastic(P, pseudo_experiment, to_plot)

addpath('../temperature_driven/')
temperature_pseudo = pseudo_experiment.temperature;
stress_pseudo = pseudo_experiment.stress;
strain_pseudo = pseudo_experiment.strain;

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
    figure();
    box on 
    hold on
    plot(eps,stress_pseudo,'r','LineWidth',1.5)
    plot(strain_pseudo,stress_pseudo,'b','LineWidth',1.5)
    xlabel('Strain')
    ylabel('Stress (MPa)')
end
end