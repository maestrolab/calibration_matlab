function stop = fmincon_plot(x,optimValues,state)
global fun_plot
stop = false;
if(strcmp(flag,'init')) % Set up the plot
    xlabel Strain
    ylabel Stress
    title('Best Work-loop')
end
axx = gca;
cla(axx);

fun_plot(x);