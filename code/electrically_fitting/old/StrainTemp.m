function [ ] = StrainTemp( filename, StrainRange,...
    TimeSRange, TimeTRange, TempRange)

% Function that reads Excel files with MTS Code to plot Strain vs. Stress
% Curves

% Reading Excel File 
    filename  = filename;
    Strain    = xlsread(filename,StrainRange);
    Temp_0    = xlsread(filename,TempRange);
    TimeS     = xlsread(filename,TimeSRange);
    TimeT0    = xlsread(filename,TimeTRange);
    
  
% Filtering Data
    Temp   = smooth(Temp_0,0.1,'loess');
    
% Time Shifting
    TimeT = TimeT0 - TimeT0(1);
    
% Plotting        
     % Temperature vs. Strain   
     
        left_color = [0 0.4470 0.7410];
        right_color = [0.850 0.3250 0.0980];
        set(figure,'defaultAxesColorOrder',[left_color; right_color])

        yyaxis right 
        plot(TimeT,Temp,'Color',[0.850 0.3250 0.0980],'Linewidth',2,'LineStyle','-.')
        xlabel('Time (s)','FontSize',12, 'Fontname','TimesNewRoman','FontWeight','Bold')
        ylabel('Temperature (^{\circ}C)','FontSize',12, 'Fontname','TimesNewRoman','FontWeight','Bold')
        xlim( [ min(TimeS) max(TimeS) ] ) 
        ylim( [ 0 130] )
        xticks([0:20:max(TimeS) ] )
        hold on

        yyaxis left
        plot(TimeS, Strain,'Color', [0 0.4470 0.7410],'Linewidth',2)
        ylabel('Strain (%)','FontSize',12, 'Fontname','TimesNewRoman','FontWeight','Bold')
        ylim( [0 4.5 ] )
        
        legend({'Strain','Temperature'},'Fontname','Arial','Location','NorthWest')
       
        
        
        
        
end