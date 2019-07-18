function output = cost(x, lb, ub, P, MVF_0, to_plot)
global initial_error
global initial_delta_eps
global experiment

if nargin < 5
    MVF_0 = 1.0;
end
if nargin < 6
    to_plot = 'strain-stress';
end

% disp(P)
% Elastic Prediction Check
elastic_check = 'N';

% Only positive stress?
stress_flag = false;

try
    % Assigning material properties
    P = property_assignment(x, lb, ub, P, MVF_0);
    fields = fieldnames(experiment(1));
    colors = [0 0 1;
          0 0.5 0;
          1 0 0;
          0 0.75 0.75;
          0.75 0 0.75;
          0.75 0.75 0;
          0.25 0.25 0.25];
    rmse = 0;
    for i = 1:length(experiment)
        field = char(fields(i));
        t = experiment(1).time;
        eps = experiment(1).strain + P.eps_0;
        sigma = experiment(1).stress + P.sigma_0;
        current = experiment(1).power;
        [sigma_n,MVF,T,eps_t, ...
            E,MVF_r eps_t_r, ...
            h_convection, pi_t, eps_n ] = Full_Model_TC( t, eps, current, P, ...
                                                       elastic_check, ...
                                                       stress_flag);

    %         eps_n = eps_n - min(eps_n);
    %         plot(eps, sigma, 'color', colors(i,:), 'linewidth',2, 'DisplayName', field);
    %         plot(eps_n, sigma_n, '--','color', colors(i,:), 'linewidth',2)

          rmse = rmse + real(sqrt(sum(sum((sigma - sigma_n).^2))/numel(sigma)))/1e9;
    end
    rmse = rmse + pseudoelastic(P, false)/0.04;

    if (initial_error == 0)
        initial_error = rmse;
    end
      output = rmse; %/initial_error ;
%     disp('output')
%     disp(output)
catch
    output = 2;
end  
end


