function [ ] = StrainStress( filename1, StressRange1, StrainRange1,...
    filename2, StressRange2, StrainRange2,...
    filename3, StressRange3, StrainRange3)

% Function that reads Excel files with MTS Code to plot Strain vs. Stress
% Curves

% Reading Excel File 
    filename1 = filename1;
    Stress_01  = xlsread(filename1,StressRange1);
    Strain_01  = xlsread(filename1,StrainRange1);
    
    filename2 = filename2;
    Stress_02  = xlsread(filename2,StressRange2);
    Strain_02  = xlsread(filename2,StrainRange2);
    
    filename3 = filename3;
    Stress_03  = xlsread(filename3,StressRange3);
    Strain_03  = xlsread(filename3,StrainRange3);
    
    
% Filtering Data 

    Stress1 = smooth(Stress_01, 0.1,'loess');
    Strain1 = smooth(Strain_01, 0.1,'loess'); 
    
    Stress2 = smooth(Stress_02, 0.1,'loess');
    Strain2 = smooth(Strain_02, 0.1,'loess');    
 
    Stress3 = smooth(Stress_03, 0.1,'rloess');
    Strain3 = smooth(Strain_03, 0.1,'rloess'); 

    
%Plotting

hold on
box on

    plot(Strain1,Stress1,'-k', 'Linewidth', 2)
    plot(Strain2,Stress2,'--k', 'Linewidth', 2)
    plot(Strain3,Stress3,'-.k', 'Linewidth', 2)
    
    xlabel('Strain (%)','FontSize',12, 'Fontname','Arial')
    ylabel('Stress (MPa)','FontSize',12, 'Fontname','Arial')
    
    legend({'100^{\circ}C','40^{\circ}C','0^{\circ}C'},...
        'Fontname','Arial','Location','northwest')
    
    ylim([0  max(Stress1)+100])
    xlim([0  4])
    
end

