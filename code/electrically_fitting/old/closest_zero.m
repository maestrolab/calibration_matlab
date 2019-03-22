function [indices]= closest_zero(single_data)
indices = zeros(6,1);
indices(1) = 1;
j=2;
for i=2:length(single_data.strain)
    if j <= 6
        if single_data.strain(i+1) > single_data.strain(i) && ...
                single_data.strain(i-1) > single_data.strain(i)
            indices(j)= i;
            j = j+1;
        end
    end
end
end