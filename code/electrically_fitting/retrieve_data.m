function [matrix, all_data] = retrieve_data(period, duty_list, phase_list, ...
                                      n_cycles, directory)
% Default values 
     if ~exist('directory','var')
         % third parameter does not exist, so default it to something
          directory = './';
     end

% Initialize variables
    n = length(duty_list)*length(phase_list);
    matrix = zeros(n, 5);
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
            data.strain = 2e-2*xlsread(filename, sheet, ...
                                  strcat('D7:D',num2str(nRows)));
            data.stress = 1e6*xlsread(filename, sheet, ...
                                  strcat('G7:G',num2str(nRows)));
            data.power =  xlsread(filename, sheet, ...
                                  strcat('I7:I',num2str(nRows)));
            % Calculate work
            work = calculate_work(data.stress, data.strain, 1., 1.)/n_cycles;
            
            % Eliminate all data that is not relevant to last 1.5 cycle
            index_start = ceil(.75*length(data.time));
            index_end = ceil(.95*length(data.time));
            fields = fieldnames(data);
            for j=1:length(fields)
                field = char(fields(j));
                data.(field) = data.(field)(index_start:index_end);
            end
            data.stress = data.stress - data.stress(1);
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

end