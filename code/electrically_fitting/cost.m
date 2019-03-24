function output = cost(x, lb, ub, MVF_0, to_plot)
global initial_error
global initial_delta_eps
global experiment

if nargin < 4
    MVF_0 = 1.0;
end
if nargin < 5
    to_plot = 'strain-stress';
end
% Assigning material properties
P = property_assignment(x, lb, ub, MVF_0);
% disp(P)
% Elastic Prediction Check
elastic_check = 'N';

% Only positive stress?
stress_flag = true;

try
    fields = fieldnames(experiment(1));
    colors = [0 0 1;
          0 0.5 0;
          1 0 0;
          0 0.75 0.75;
          0.75 0 0.75;
          0.75 0.75 0;
          0.25 0.25 0.25];
    figure(1);
    clf(1);
    hold on

    for i = 1:length(experiment)
        field = char(fields(i));
        t = experiment(1).time;
        eps = experiment(1).strain;
        sigma = experiment(1).stress;
        current = experiment(1).power;
        [sigma_n,MVF,T,eps_t, ...
            E,MVF_r eps_t_r, ...
            h_convection, pi_t, eps ] = Full_Model_TC( t, eps, current, P, ...
                                                       elastic_check, ...
                                                       stress_flag);

%         eps_n = eps_n - min(eps_n);
        plot(eps, sigma, 'color', colors(i,:), 'linewidth',2, 'DisplayName', field);
        plot(eps, sigma_n, '--','color', colors(i,:), 'linewidth',2)
        if i == 1
            rmse = sqrt(sum((sigma-sigma_n).^2)/numel(sigma));
        else
            rmse = rmse + sqrt(sum((sigma-sigma_n).^2)/numel(sigma));
        end
    end
    legend();

    if (initial_error == 0)
        initial_error = rmse;
    end
    output = rmse/initial_error ;
%     disp('output')
%     disp(output)
catch
    output = 100.;
end  
end


