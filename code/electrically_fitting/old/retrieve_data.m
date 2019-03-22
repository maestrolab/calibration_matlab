function [matrix, all_data] = retrieve_data(period, duty_list, phase_list, ...
                                      n_cycles, directory)
% Default values 
     if ~exist('directory','var')
         % third parameter does not exist, so default it to something
          directory = './';
     end

% Initialize variables
    n = length(duty_list)*length(phase_list);
    matrix = zeros(n, 4);
    all_data = containers.Map(linspace(1,n, n), zeros(1, n), ...
                             'UniformValues', false);
    
    filename = strcat(directory, 'Period_', int2str(period));

    c = {'%, '};

    i = 1;
    for duty = duty_list
        for phase = phase_list
            sheet = char(strcat(int2str(duty), c ,int2str(phase),'%'));
            
            % Finding out how many rows there are
            array = xlsread( filename, sheet);
            lengths = size( array );
            nRows = lengths(1);
            nRows_head = 6; % rows without data
            
            % extracting data
            disp(strcat('Processing data for: period=', int2str(period), ...
                        ', duty=', int2str(duty), ', phase=', int2str(phase)))
            data.time =   xlsread(filename, sheet, ...
                                  strcat('B7:B',num2str(nRows)));
            data.time = data.time - data.time(1);
            data.load =   xlsread(filename, sheet, ...
                                  strcat('C7:C',num2str(nRows)));
            data.strain = xlsread(filename, sheet, ...
                                  strcat('D7:D',num2str(nRows)));
            data.area =   xlsread(filename, sheet, ...
                                  strcat('F7:F',num2str(nRows)));
            data.stress = xlsread(filename, sheet, ...
                                  strcat('G7:G',num2str(nRows)));
            data.power =  xlsread(filename, sheet, ...
                                  strcat('I7:I',num2str(nRows)));
            data.cycles_indexes = closest_zero(data);
            % Calculate work
            work = calculate_work(data.stress, data.strain, 1., 1.)/n_cycles;
            data.work = work;
            
            % Calculate cycle intervals (strain == 0)
            all_data(i)=data;
            matrix(i,1) = period;
            matrix(i,2) = duty;
            matrix(i,3) = phase;
            matrix(i,4) = work;
            matrix(i,5) = max(data.stress);
            i = i +1;
        end
    end

    
  
% Filtering Data 
    %Stress = smooth(Stress_0, 0.01,'loess');
    % Temp   = smooth(Temp_0,0.1,'loess');
    
% Time Shifting
    
    
% Calculating work


end