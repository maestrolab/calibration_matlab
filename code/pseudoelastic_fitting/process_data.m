function [experiment] = process_data(filepath, stress_in_MPa, reorder)
%Read data from experiments. For constant stress sigma:
% - data_sigma(1): Temperature (in Celsius)
% - data_sigma(2): Strain
% - data_sigma(3): Stress
if nargin < 2
    stress_in_MPa = false;
    reorder = false;
end

files = dir(strcat(filepath, '*.txt'));
disp(files)
for i = 1:length(files)
    filename = files(i).name;
    field = filename(1:end-4);
    disp(strcat(filepath, field))
    data.(field) = textread(strcat(filepath, filename));
    T.(field) = data.(field)(:,1) + 273.15;
    eps.(field) = data.(field)(:,2);
%     eps.(field) = eps.(field) - min(eps.(field));
    if stress_in_MPa
        sigma.(field) = 1e6*data.(field)(:,3);
    else
        sigma.(field) = data.(field)(:,3);
    end
    
    % Reordering data
    if reorder
        [Tmin, I] = min(T.(field));
        T.(field) = [T.(field)(I:end)' T.(field)(1:I)']';
        eps.(field) = [eps.(field)(I:end)' eps.(field)(1:I)']';
        sigma.(field) = [sigma.(field)(I:end)' sigma.(field)(1:I)']';
    end
end

%% Smooth the data
fields = fieldnames(T);
for i = 1:length(fields)
    disp(i)
    field = char(fields(i));
    disp(field)
    disp(fields)
    T.(field) = smooth(T.(field),0.01,'rloess');
    eps.(field) = smooth(eps.(field),0.01,'rloess');
    sigma.(field) = smooth(sigma.(field),0.01,'rloess');
end
experiment = [T, eps, sigma];
end

