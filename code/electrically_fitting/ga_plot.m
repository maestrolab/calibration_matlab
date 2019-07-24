function state = ga_plot(options, state, flag)
global fun_plot
% GAPLOTCHANGE Plots the logarithmic change in the best score from the 
% previous generation.
%  

if(strcmp(flag,'init')) % Set up the plot
    xlabel Strain
    ylabel Stress
    title('Best Work-loop')
end
axx = gca;
cla(axx);
[score, index] = min(state.Score); % Best score in the current generation
values = state.Population(index, :);
fun_plot(values);