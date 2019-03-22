clear; clc; close all;

period_list = [21, 25, 35];
duty_list = [50, 69];
phase_list = [-25, 0, 25, 50];
n_cycles = 5;

n_periods = length(period_list);
n_duty = length(duty_list);
n_phase = length(phase_list);
n_combinations = n_periods*n_duty*n_phase;
DOE_matrix = zeros(n_combinations, 5);

% Extracting data
directory = '../data/';
data = containers.Map(linspace(1,n_combinations, n_combinations), ...
                      zeros(1, n_combinations), 'UniformValues', false);
                  
for i = 1:n_periods
   period = period_list(i);
   [DOE_matrix((i-1)*n_duty*n_phase+1 : i*n_duty*n_phase,:),temp] = ...
       retrieve_data(period, duty_list, phase_list, n_cycles, ...
       directory);
   for j=1:n_duty*n_phase
    data((i-1)*n_duty*n_phase+ j) = temp(j);
   end
end

% Taking the average
% data_av = average(data, [3,4,5])

% Write to file
fileID = fopen(strcat(directory,'work.txt'),'w');
fprintf(fileID,'period\tduty\tphase\twork\tstress\n');
formatSpec = '%8.3f\t%8.3f\t%8.3f\t%8.3f\t%8.3f\n';
for ii=1:n_combinations
    fprintf(fileID,formatSpec, DOE_matrix(ii,:));
end
fclose(fileID);

% plotting, You can pick which combonations you want to see
x_plot = 'strain';
y_plot = 'stress';
x_label = 'Strain (m/m)';
y_label = 'Stress (MPa)';

period_list = [21, 25, 35];
duty_list = [50];
phase_list = [-25];
plotting(DOE_matrix, data, period_list, duty_list, ...,
                       phase_list, x_plot, y_plot, x_label, y_label)
                   

