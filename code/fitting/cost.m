function output = cost(x, lb, ub, MVF_0, to_plot)
global initial_error
global initial_delta_eps
global experiment

if nargin < 4
    MVF_0 = 1.0;
end
if nargin < 5
    to_plot = ['stress-strain']; %['temperature-strain']; % ['stress-strain'];
end
% Assigning material properties
P = property_assignment(x, lb, ub, MVF_0);
% disp(P)
% Elastic Prediction Check
elastic_check = 'N';

% Integration Scheme
integration_scheme = 'I';

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

    for i = 1:length(fields)
        field = char(fields(i));
        T = experiment(1).(field);
        eps = experiment(2).(field);
        sigma = experiment(3).(field);
        [eps_n, MVF,eps_t,E,MVF_r,eps_t_r ] = Full_Model_stress(T, sigma, P, ...
                                                                  elastic_check, ...
                                                                  integration_scheme);
%         eps_n = eps_n - min(eps_n);
        
        if ismember('temperature-strain', to_plot)
            plot(T, eps, 'color', colors(i,:), 'linewidth',2, 'DisplayName', field);
            plot(T, eps_n, '--','color', colors(i,:), 'linewidth',2)
        elseif ismember('strain-stress', to_plot)
            plot(eps, sigma, 'color', colors(i,:), 'linewidth',2, 'DisplayName', field);
            plot(eps_n, sigma, '--','color', colors(i,:), 'linewidth',2)
        end
        if i == 1
            rmse = sqrt(sum((eps-eps_n).^2)/numel(eps));
            delta_eps = abs((max(eps) - min(eps)) - (max(eps_n) - min(eps_n)));
        else
            rmse = rmse + sqrt(sum((eps-eps_n).^2)/numel(eps));
            delta_eps = delta_eps + abs((max(eps) - min(eps)) - (max(eps_n) - min(eps_n)));
        end
    end
    legend();
    delta_eps = delta_eps/length(fields);

    if (initial_error == 0)
        initial_error = rmse;
        initial_delta_eps = delta_eps;
    end
    output = (rmse/initial_error + delta_eps/initial_delta_eps)/2.;
    output = rmse/initial_error ;
%     disp('output')
%     disp(output)
catch
    output = 100.;
end  
end
