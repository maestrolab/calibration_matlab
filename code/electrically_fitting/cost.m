function output = cost(x, lb, ub, P, experiment, pseudo_experiment, MVF_0, to_plot)

if nargin < 7
    MVF_0 = 1.0;
end
if nargin < 8
    to_plot = false;
end

% disp(P)
% Elastic Prediction Check
elastic_check = 'N';

% Only positive stress?
stress_flag = false;

 try
    % Assigning material properties
    P = property_assignment(x, lb, ub, P, experiment, MVF_0);
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
        t = experiment(1).time - min(experiment(1).time);
        eps = experiment(1).strain - experiment(1).strain(1,1)+ P.eps_0;
        sigma = experiment(1).stress - experiment(1).stress(1,1) + P.sigma_0;

        if P.delay>=0
            current = [experiment(1).power(1+P.delay:end); experiment(1).power(1:P.delay)];
        else
            current = [experiment(1).power(end+P.delay+1:end); experiment(1).power(1:end+P.delay)];
        end
        [sigma_n,MVF,T,eps_t, ...
            E,MVF_r eps_t_r, ...
            h_convection, pi_t, eps_n ] = Full_Model_TC( t, eps, current, P, ...
                                                       elastic_check, ...
                                                       stress_flag);

        eps_n = eps_n;

        start = ceil(2*length(sigma)/3);
        finish = length(sigma);
        if to_plot
%             figure(1);
%            clf(1);
%             box on 
            hold on
            plot(eps(start:finish), sigma(start:finish), 'color', colors(i,:), 'linewidth',2, 'DisplayName', field);
            plot(eps_n(start:finish), sigma_n(start:finish), '--','color', colors(i,:), 'linewidth',2)
        end
          rmse = rmse + sqrt(sum((sigma(start:finish) - sigma_n(start:finish)).^2)/numel(sigma(start:finish)))/1e9;
    end

      output = rmse;
    if isreal(output) ~= true
      output = abs(output)*10;
    end
    %     disp('output')
    %     disp(output)
catch
    output = 100;
end

% try
%     output = output + pseudoelastic(P, pseudo_experiment, false)/0.04;
% catch
%     output = output + 200;
% end
end


