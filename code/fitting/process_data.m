function [experiment] = process_data(filepath)
%Read data from experiments. For constant stress sigma:
% - data_sigma(1): Temperature (in Celsius)
% - data_sigma(2): Strain
% - data_sigma(3): Stress
files = dir(strcat(filepath, '*.txt'));
disp(files)
for i = 1:length(files)
    filename = files(i).name;
    field = filename(1:end-4);
    disp(strcat(filepath, field))
    data.(field) = textread(strcat(filepath, filename));
    T.(field) = data.(field)(:,1) + 273.15;
    eps.(field) = data.(field)(:,2);
    sigma.(field) = data.(field)(:,3);
    [Tmin, I] = min(T.(field));
    
    % Reordering data
    T.(field) = [T.(field)(I:end)' T.(field)(1:I)']';
    eps.(field) = [eps.(field)(I:end)' eps.(field)(1:I)']';
    sigma.(field) = [sigma.(field)(I:end)' sigma.(field)(1:I)']';
end

experiment = [T, eps, sigma];
end

