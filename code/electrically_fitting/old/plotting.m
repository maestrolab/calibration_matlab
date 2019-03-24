function [] = plotting(DOE_matrix, data, period_list, duty_list, ...,
                       phase_list, plot_x, plot_y, label_x, label_y, ...
                       cycles)

    for period=period_list
        for duty=duty_list
            for phase=phase_list
                ii = find(DOE_matrix(:,1)==period & DOE_matrix(:,2)==duty & ...
                     DOE_matrix(:,3)==phase);
                disp(ii)
                data_plot = data(ii)
                
                x = data_plot.(plot_x);
                y = data_plot.(plot_y);
%                 disp(data_plot.cycle_interval)
%                 disp(data_plot.cycle_interval*[0,1,2,3,4,5])
%                 x_scatter = plot_x(data_plot.cycle_interval*[0,1,2,3,4,5]+1);
%                 y_scatter = plot_y(data_plot.cycle_interval*[0,1,2,3,4,5]+1);
                % Filtering for MPa
                displayname = strcat('T=',int2str(period), ...
                                     ', duty=',int2str(duty), ...
                                     ', phase=',int2str(phase));
                plot(x, y, 'DisplayName',displayname)
                hold on
%                 scatter(x_scatter, y_scatter)
                
            end
        end
    end
   xlabel(label_x)
   ylabel(label_y)
   legend()
end