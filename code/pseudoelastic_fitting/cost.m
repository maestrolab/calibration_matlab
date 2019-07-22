function output = cost(x, lb, ub, MVF_0, to_plot)
global initial_error
global initial_delta_eps
global experiment

if nargin < 4
    MVF_0 = 0.0;
end
if nargin < 5
    to_plot = false;
end
% Assigning material properties
P = property_assignment(x, lb, ub, MVF_0);

try
    rmse = pseudoelastic(P, to_plot);

    if (initial_error == 0)
        initial_error = rmse;
    end
    output = rmse; %/initial_error ;
catch
    output = 2;
end  
end


