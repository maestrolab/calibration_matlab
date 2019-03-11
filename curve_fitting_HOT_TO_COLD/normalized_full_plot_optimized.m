function output = normalized_full_plot_optimized(x, lb, ub, filename)
% Inputs:
% - x(1): E_M
% - x(2): E_A
% - x(3): M_s
% - x(4): M_s - M_f
% - x(5): A_s
% - x(6): A_f - A_s
% - x(7): C_M
% - x(8): C_A
% - x(9): H_min
% - x(10): H_max - H_min
% - x(11): k
% - x(12): n_1 
% - x(13): n_2
% - x(14): n_3
% - x(15): n_4
%alphas and sigma_crit are equal to zero in this problem

% Denormalizing
x = x.*(ub - lb) + lb;

%Read data from experiments. For constant stress sigma:
% - data_sigma(1): Temperature (in Celsius)
% - data_sigma(2): Strain
% - data_sigma(3): Stress

if filename == "karaman"
   
    data_50 = textread('data/Karaman/filtered_data_50MPa.txt');
    data_100 = textread('data/Karaman/filtered_data_100MPa.txt');
    data_200 = textread('data/Karaman/filtered_data_200MPa.txt');
    data_300 = textread('data/Karaman/filtered_data_300MPa.txt');
    data_400 = textread('data/Karaman/filtered_data_400MPa.txt');
    data_500 = textread('data/Karaman/filtered_data_500MPa.txt');
    data_600 = textread('data/Karaman/filtered_data_600MPa.txt');



    T_50 = data_50(:,1) + 273.15;
    T_100 = data_100(:,1) + 273.15;
    T_200 = data_200(:,1) + 273.15;
    T_300 = data_300(:,1) + 273.15;
    T_400 = data_400(:,1) + 273.15;
    T_500 = data_500(:,1) + 273.15;
    T_600 = data_600(:,1) + 273.15;



    eps_50 = data_50(:,2);
    eps_100 = data_100(:,2);
    eps_200 = data_200(:,2);
    eps_300 = data_300(:,2);
    eps_400 = data_400(:,2);
    eps_500 = data_500(:,2);
    eps_600 = data_600(:,2);



    eps_50 = eps_50 - min(eps_50);
    eps_100 = eps_100 - min(eps_100);
    eps_200 = eps_200 - min(eps_200);
    eps_300 = eps_300 - min(eps_300);
    eps_400 = eps_400 - min(eps_400);
    eps_500 = eps_500 - min(eps_500);
    eps_600 = eps_600 - min(eps_600);



    sigma_50 = data_50(:,3);
    sigma_100 = data_100(:,3);
    sigma_200 = data_200(:,3);
    sigma_300 = data_300(:,3);
    sigma_400 = data_400(:,3);
    sigma_500 = data_500(:,3);
    sigma_600 = data_600(:,3);



    [min_T_50, I_50] = min(T_50);
    [min_T_100, I_100] = min(T_100);
    [min_T_200, I_200] = min(T_200);
    [min_T_300, I_300] = min(T_300);
    [min_T_400, I_400] = min(T_400);
    [min_T_500, I_500] = min(T_500);
    [min_T_600, I_600] = min(T_600);



    T_50 = [T_50(I_50:end)' T_50(1:I_50)']';
    T_100 = [T_100(I_100:end)' T_100(1:I_100)']';
    T_200 = [T_200(I_200:end)' T_200(1:I_200)']';
    T_300 = [T_300(I_300:end)' T_300(1:I_300)']';
    T_400 = [T_400(I_400:end)' T_400(1:I_400)']';
    T_500 = [T_500(I_500:end)' T_500(1:I_500)']';
    T_600 = [T_600(I_600:end)' T_600(1:I_600)']';



    eps_50 = [eps_50(I_50:end)' eps_50(1:I_50)']';
    eps_100 = [eps_100(I_100:end)' eps_100(1:I_100)']';
    eps_200 = [eps_200(I_200:end)' eps_200(1:I_200)']';
    eps_300 = [eps_300(I_300:end)' eps_300(1:I_300)']';
    eps_400 = [eps_400(I_400:end)' eps_400(1:I_400)']';
    eps_500 = [eps_500(I_500:end)' eps_500(1:I_500)']';
    eps_600 = [eps_600(I_600:end)' eps_600(1:I_600)']';


    sigma_50 = [sigma_50(I_50:end)' sigma_50(1:I_50)']';
    sigma_100 = [sigma_100(I_100:end)' sigma_100(1:I_100)']';
    sigma_200 = [sigma_200(I_200:end)' sigma_200(1:I_200)']';
    sigma_300 = [sigma_300(I_300:end)' sigma_300(1:I_300)']';
    sigma_400 = [sigma_400(I_400:end)' sigma_400(1:I_400)']';
    sigma_500 = [sigma_500(I_500:end)' sigma_500(1:I_500)']';
    sigma_600 = [sigma_600(I_600:end)' sigma_600(1:I_600)']';


    % INPUT:
    % MATERIAL PARAMETERS (Structure: P)
    % Young's Modulus for Austenite and Martensite 
    P.E_M = x(1);
    P.E_A = x(1) - x(2);
    % Transformation temperatures (M:Martensite, A:
    % Austenite), (s:start,f:final)
    P.M_s = x(3);
    P.M_f = x(3) - x(4);
    P.A_s = x(5);
    P.A_f = x(6) + x(5);

    % Slopes of transformation boundarings into austenite (C_A) and
    % martensite (C_M) at Calibration Stress 
    P.C_M = x(7);
    P.C_A = x(8);

    % Maximum and minimum transformation strain
    P.H_min = x(9);
    P.H_sat = x(9) + x(10);

    P.k = x(11);
    P.sig_crit = 0;

    % Smoothn hardening parameters 
    % NOTE: smoothness parameters must be 1 for explicit integration scheme
    P.n1 = x(12);
    P.n2 = x(13);
    P.n3 = x(14);
    P.n4 = x(15);

    % Coefficient of thermal expansion
    P.alpha_M = x(16);
    P.alpha_A = x(17);

    % Algorithmic delta for modified smooth hardening function
    P.delta=1e-5;

    % Calibration Stress
    P.sig_cal=200E6;

    % Tolerance for change in MVF during implicit iteration
    P.MVF_tolerance=1e-8;

    disp(P)
    %Transform into MPa
    sigma_50 = 1e6 * 50*ones(size(sigma_50));
    sigma_100 = 1e6 * 100*ones(size(sigma_100));
    sigma_200 = 1e6 * 200*ones(size(sigma_200));
    sigma_300 = 1e6 * 300*ones(size(sigma_300));
    sigma_400 = 1e6 * 400*ones(size(sigma_400));
    sigma_500 = 1e6 * 500*ones(size(sigma_500));
    sigma_600 = 1e6 * 600*ones(size(sigma_600));


    % Elastic Prediction Check
    elastic_check = 'N';

    % Integration Scheme
    integration_scheme = 'I';


    [eps_num_50, MVF,eps_t,E,MVF_r,eps_t_r ] = Full_Model_stress( T_50, sigma_50, P, elastic_check, integration_scheme );
    [eps_num_100, MVF,eps_t,E,MVF_r,eps_t_r ] = Full_Model_stress( T_100, sigma_100, P, elastic_check, integration_scheme );
    [eps_num_200, MVF,eps_t,E,MVF_r,eps_t_r ] = Full_Model_stress( T_200, sigma_200, P, elastic_check, integration_scheme );
    [eps_num_300, MVF,eps_t,E,MVF_r,eps_t_r ] = Full_Model_stress( T_300, sigma_300, P, elastic_check, integration_scheme );
    [eps_num_400, MVF,eps_t,E,MVF_r,eps_t_r ] = Full_Model_stress( T_400, sigma_400, P, elastic_check, integration_scheme );
    [eps_num_500, MVF,eps_t,E,MVF_r,eps_t_r ] = Full_Model_stress( T_500, sigma_500, P, elastic_check, integration_scheme );
    [eps_num_600, MVF,eps_t,E,MVF_r,eps_t_r ] = Full_Model_stress( T_600, sigma_600, P, elastic_check, integration_scheme );

    eps_num_50 = eps_num_50 - min(eps_num_50);
    eps_num_100 = eps_num_100 - min(eps_num_100);
    eps_num_200 = eps_num_200 - min(eps_num_200);
    eps_num_300 = eps_num_300 - min(eps_num_300);
    eps_num_400 = eps_num_400 - min(eps_num_400);
    eps_num_500 = eps_num_500 - min(eps_num_500);
    eps_num_600 = eps_num_600 - min(eps_num_600);


    figure()
    box on
    hold on
    plot(T_50, eps_50,'b','LineWidth',1.5)
    plot(T_50, eps_num_50,'r','LineWidth',1.5)
    xlabel('Temperature (K)')
    ylabel('Strain (m/m)')
    title('50MPa')

    figure()
    box on
    hold on
    plot(T_100, eps_100,'b','LineWidth',1.5)
    plot(T_100, eps_num_100,'r','LineWidth',1.5)
    xlabel('Temperature (K)')
    ylabel('Strain (m/m)')
    title('100MPa')

    figure()
    box on
    hold on
    plot(T_200, eps_200,'b','LineWidth',1.5)
    plot(T_200, eps_num_200,'r','LineWidth',1.5)
    xlabel('Temperature (K)')
    ylabel('Strain (m/m)')
    title('200MPa')

    figure()
    box on
    hold on
    plot(T_300, eps_300,'b','LineWidth',1.5)
    plot(T_300, eps_num_300,'r','LineWidth',1.5)
    xlabel('Temperature (K)')
    ylabel('Strain (m/m)')
    title('300MPa')

    figure()
    box on
    hold on
    plot(T_400, eps_400,'b','LineWidth',1.5)
    plot(T_400, eps_num_400,'r','LineWidth',1.5)
    xlabel('Temperature (K)')
    ylabel('Strain (m/m)')
    title('400MPa')

    figure()
    box on
    hold on
    plot(T_500, eps_500,'b','LineWidth',1.5)
    plot(T_500, eps_num_500,'r','LineWidth',1.5)
    xlabel('Temperature (K)')
    ylabel('Strain (m/m)')
    title('500MPa')

    figure()
    box on
    hold on
    plot(T_600, eps_600,'b','LineWidth',1.5)
    plot(T_600, eps_num_600,'r','LineWidth',1.5)
    xlabel('Temperature (K)')
    ylabel('Strain (m/m)')
    title('600MPa')
    
end

if filename == "original"
    
    %Read data from experiments. For constant stress sigma:
    % - data_sigma(1): Temperature (in Celsius)
    % - data_sigma(2): Strain
    % - data_sigma(3): Stress
    
    data_50 = textread('data/Original/filtered_data_50MPa.txt');
    data_100 = textread('data/Original/filtered_data_100MPa.txt');
    data_150 = textread('data/Original/filtered_data_150MPa.txt');
    % data_172 = textread('data/Original/filtered_data_172MPa.txt');
    data_200 = textread('data/Original/filtered_data_200MPa.txt');

    T_50 = data_50(:,1) + 273.15;
    T_100 = data_100(:,1) + 273.15;
    T_150 = data_150(:,1) + 273.15;
    % T_172 = data_172(:,1) + 273.15;
    T_200 = data_200(:,1) + 273.15;

    eps_50 = data_50(:,2);
    eps_100 = data_100(:,2);
    eps_150 = data_150(:,2);
    % eps_172 = data_172(:,2);
    eps_200 = data_200(:,2);

    sigma_50 = data_50(:,3);
    sigma_100 = data_100(:,3);
    sigma_150 = data_150(:,3);
    % sigma_172 = data_172(:,3);
    sigma_200 = data_200(:,3);

    [min_T_50, I_50] = min(T_50);
    [min_T_100, I_100] = min(T_100);
    [min_T_150, I_150] = min(T_150);
    % [min_T_172, I_172] = min(T_172);
    [min_T_200, I_200] = min(T_200);

    T_50 = [T_50(I_50:end)' T_50(1:I_50)']';
    T_100 = [T_100(I_100:end)' T_100(1:I_100)']';
    T_150 = [T_150(I_150:end)' T_150(1:I_150)']';
    % T_172 = [T_172(I_172:end)' T_172(1:I_172)']';
    T_200 = [T_200(I_200:end)' T_200(1:I_200)']';

    eps_50 = [eps_50(I_50:end)' eps_50(1:I_50)']';
    eps_100 = [eps_100(I_100:end)' eps_100(1:I_100)']';
    eps_150 = [eps_150(I_150:end)' eps_150(1:I_150)']';
    % eps_172 = [eps_172(I_172:end)' eps_172(1:I_172)']';
    eps_200 = [eps_200(I_200:end)' eps_200(1:I_200)']';

    sigma_50 = [sigma_50(I_50:end)' sigma_50(1:I_50)']';
    sigma_100 = [sigma_100(I_100:end)' sigma_100(1:I_100)']';
    sigma_150 = [sigma_150(I_150:end)' sigma_150(1:I_150)']';
    % sigma_172 = [sigma_172(I_172:end)' sigma_172(1:I_172)']';
    sigma_200 = [sigma_200(I_200:end)' sigma_200(1:I_200)']';

    % INPUT:
    % MATERIAL PARAMETERS (Structure: P)
    % Young's Modulus for Austenite and Martensite 
    P.E_M = x(1);
    P.E_A = x(1) - x(2);
    % Transformation temperatures (M:Martensite, A:
    % Austenite), (s:start,f:final)
    P.M_s = x(3);
    P.M_f = x(3) - x(4);
    P.A_s = x(5);
    P.A_f = x(6) + x(5);

    % Slopes of transformation boundarings into austenite (C_A) and
    % martensite (C_M) at Calibration Stress 
    P.C_M = x(7);
    P.C_A = x(8);

    % Maximum and minimum transformation strain
    P.H_min = x(9);
    P.H_sat = x(9) + x(10);

    P.k = x(11);
    P.sig_crit = 0;

    % Coefficient of thermal expansion
    P.alpha = 0.;

    % Smoothn hardening parameters 
    % NOTE: smoothness parameters must be 1 for explicit integration scheme
    P.n1 = x(12);
    P.n2 = x(13);
    P.n3 = x(14);
    P.n4 = x(15);
    
    % Coefficient of thermal expansion
    P.alpha_M = x(16);
    P.alpha_A = x(17);

    % Algorithmic delta for modified smooth hardening function
    P.delta=1e-5;

    % Calibration Stress
    P.sig_cal=200E6;

    % Tolerance for change in MVF during implicit iteration
    P.MVF_tolerance=1e-8;

    disp(P)
    %Transform into MPa
    sigma_50 = 1e6 * 50*ones(size(sigma_50));
    sigma_100 = 1e6 * 100*ones(size(sigma_100));
    sigma_150 = 1e6 * 150*ones(size(sigma_150));
    % sigma_172 = 1e6 * 172*ones(size(sigma_172));
    sigma_200 = 1e6 * 200*ones(size(sigma_200));

    % Elastic Prediction Check
    elastic_check = 'N';

    % Integration Scheme
    integration_scheme = 'I';


    [eps_num_50, MVF,eps_t,E,MVF_r,eps_t_r ] = Full_Model_stress( T_50, sigma_50, P, elastic_check, integration_scheme );
    [eps_num_100, MVF,eps_t,E,MVF_r,eps_t_r ] = Full_Model_stress( T_100, sigma_100, P, elastic_check, integration_scheme );
    [eps_num_150, MVF,eps_t,E,MVF_r,eps_t_r ] = Full_Model_stress( T_150, sigma_150, P, elastic_check, integration_scheme );
    % [eps_num_172, MVF,eps_t,E,MVF_r,eps_t_r ] = Full_Model_stress( T_172, sigma_172, P, elastic_check, integration_scheme );
    [eps_num_200, MVF,eps_t,E,MVF_r,eps_t_r ] = Full_Model_stress( T_200, sigma_200, P, elastic_check, integration_scheme );

    eps_num_50 = eps_num_50 - min(eps_num_50);
    eps_num_100 = eps_num_100 - min(eps_num_100);
    eps_num_150 = eps_num_150 - min(eps_num_150);
    % eps_num_172 = eps_num_172 - min(eps_num_172);
    eps_num_200 = eps_num_200 - min(eps_num_200);

    figure()
    box on
    hold on
    plot(T_50, eps_50,'b','LineWidth',1.5)
    plot(T_50, eps_num_50,'r','LineWidth',1.5)
    xlabel('Temperature (K)')
    ylabel('Strain (m/m)')
    title('50MPa')

    figure()
    box on
    hold on
    plot(T_100, eps_100,'b','LineWidth',1.5)
    plot(T_100, eps_num_100,'r','LineWidth',1.5)
    xlabel('Temperature (K)')
    ylabel('Strain (m/m)')
    title('100MPa')

    figure()
    box on
    hold on
    plot(T_150, eps_150,'b','LineWidth',1.5)
    plot(T_150, eps_num_150,'r','LineWidth',1.5)
    xlabel('Temperature (K)')
    ylabel('Strain (m/m)')
    title('150MPa')

%     figure()
%     box on
%     hold on
%     plot(T_172, eps_172,'b','LineWidth',1.5)
%     plot(T_172, eps_num_172,'r','LineWidth',1.5)
%     title('172MPa')

    figure()
    box on
    hold on
    plot(T_200, eps_200,'b','LineWidth',1.5)
    plot(T_200, eps_num_200,'r','LineWidth',1.5)
    title('200MPa')
    xlabel('Temperature (K)')
    ylabel('Strain (m/m)')
    title('200MPa')
    
end

if filename == "numerical_experimental_comparison"
    
    %Read data from experiments. For constant stress sigma:
    % - data_sigma(1): Temperature (in Celsius)
    % - data_sigma(2): Strain
    % - data_sigma(3): Stress
    
    data_F1 = textread('data/numerical_experimental_comparison/February27_Test1.txt');
    data_F2 = textread('data/numerical_experimental_comparison/February28_Test2.txt');
    data_M1 = textread('data/numerical_experimental_comparison/March8_2cpm.txt');
    data_M2 = textread('data/numerical_experimental_comparison/March8_6cpm.txt');

    T_F1 = data_F1(:,1) + 273.15;
    T_F2 = data_F2(:,1) + 273.15;
    T_M1 = data_M1(:,1) + 273.15;
    T_M2 = data_M2(:,1) + 273.15;

    eps_F1 = data_F1(:,2);
    eps_F2 = data_F2(:,2);
    eps_M1 = data_M1(:,2);
    eps_M2 = data_M2(:,2);

    sigma_F1 = data_F1(:,3);
    sigma_F2 = data_F2(:,3);
    sigma_M1 = data_M1(:,3);
    sigma_M2 = data_M2(:,3);

    [min_T_F1, I_F1] = min(T_F1);
    [min_T_F2, I_F2] = min(T_F2);
    [min_T_M1, I_M1] = min(T_M1);
    [min_T_M2, I_M2] = min(T_M2);

    T_F1 = [T_F1(I_F1:end)' T_F1(1:I_F1)']';
    T_F2 = [T_F2(I_F2:end)' T_F2(1:I_F2)']';
    T_M1 = [T_M1(I_M1:end)' T_M1(1:I_M1)']';
    T_M2 = [T_M2(I_M2:end)' T_M2(1:I_M2)']';

    eps_F1 = [eps_F1(I_F1:end)' eps_F1(1:I_F1)']';
    eps_F2 = [eps_F2(I_F2:end)' eps_F2(1:I_F2)']';
    eps_M1 = [eps_M1(I_M1:end)' eps_M1(1:I_M1)']';
    eps_M2 = [eps_M2(I_M2:end)' eps_M2(1:I_M2)']';

    sigma_F1 = [sigma_F1(I_F1:end)' sigma_F1(1:I_F1)']';
    sigma_F2 = [sigma_F2(I_F2:end)' sigma_F2(1:I_F2)']';
    sigma_M1 = [sigma_M1(I_M1:end)' sigma_M1(1:I_M1)']';
    sigma_M2 = [sigma_M2(I_M2:end)' sigma_M2(1:I_M2)']';

    % INPUT:
    % MATERIAL PARAMETERS (Structure: P)
    % Young's Modulus for Austenite and Martensite 
    P.E_M = x(1);
    P.E_A = x(1) - x(2);
    % Transformation temperatures (M:Martensite, A:
    % Austenite), (s:start,f:final)
    P.M_s = x(3);
    P.M_f = x(3) - x(4);
    P.A_s = x(5);
    P.A_f = x(6) + x(5);

    % Slopes of transformation boundarings into austenite (C_A) and
    % martensite (C_M) at Calibration Stress 
    P.C_M = x(7);
    P.C_A = x(8);

    % Maximum and minimum transformation strain
    P.H_min = x(9);
    P.H_sat = x(9) + x(10);

    P.k = x(11);
    P.sig_crit = 0;

    % Coefficient of thermal expansion
    P.alpha = 0.;

    % Smoothn hardening parameters 
    % NOTE: smoothness parameters must be 1 for explicit integration scheme
    P.n1 = x(12);
    P.n2 = x(13);
    P.n3 = x(14);
    P.n4 = x(15);
    
    % Coefficient of thermal expansion
    P.alpha_M = x(16);
    P.alpha_A = x(17);

    % Algorithmic delta for modified smooth hardening function
    P.delta=1e-5;

    % Calibration Stress
    P.sig_cal=200E6;

    % Tolerance for change in MVF during implicit iteration
    P.MVF_tolerance=1e-8;

    disp(P)
    %Transform into MPa
    sigma_F1 = 1e6 * 50*ones(size(sigma_F1));
    sigma_F2 = 1e6 * 100*ones(size(sigma_F2));
    sigma_M1 = 1e6 * 150*ones(size(sigma_M1));
    sigma_M2 = 1e6 * 172*ones(size(sigma_M2));

    % Elastic Prediction Check
    elastic_check = 'N';

    % Integration Scheme
    integration_scheme = 'I';


    [eps_num_F1, MVF,eps_t,E,MVF_r,eps_t_r ] = Full_Model_stress( T_F1, sigma_F1, P, elastic_check, integration_scheme );
    [eps_num_F2, MVF,eps_t,E,MVF_r,eps_t_r ] = Full_Model_stress( T_F2, sigma_F2, P, elastic_check, integration_scheme );
    [eps_num_M1, MVF,eps_t,E,MVF_r,eps_t_r ] = Full_Model_stress( T_M1, sigma_M1, P, elastic_check, integration_scheme );
    [eps_num_M2, MVF,eps_t,E,MVF_r,eps_t_r ] = Full_Model_stress( T_M2, sigma_M2, P, elastic_check, integration_scheme );

    eps_num_F1 = eps_num_F1 - min(eps_num_F1);
    eps_num_F2 = eps_num_F2 - min(eps_num_F2);
    eps_num_M1 = eps_num_M1 - min(eps_num_M1);
    eps_num_M2 = eps_num_M2 - min(eps_num_M2);

    figure()
    box on
    hold on
    plot(T_F1, eps_F1,'b','LineWidth',1.5)
    plot(T_F1, eps_num_F1,'r','LineWidth',1.5)
    xlabel('Temperature (K)')
    ylabel('Strain (m/m)')
    title('F1 MPa')

    figure()
    box on
    hold on
    plot(T_F2, eps_F2,'b','LineWidth',1.5)
    plot(T_F2, eps_num_F2,'r','LineWidth',1.5)
    xlabel('Temperature (K)')
    ylabel('Strain (m/m)')
    title('F2 MPa')

    figure()
    box on
    hold on
    plot(T_M1, eps_M1,'b','LineWidth',1.5)
    plot(T_M1, eps_num_M1,'r','LineWidth',1.5)
    xlabel('Temperature (K)')
    ylabel('Strain (m/m)')
    title('M1 MPa')

    figure()
    box on
    hold on
    plot(T_M2, eps_M2,'b','LineWidth',1.5)
    plot(T_M2, eps_num_M2,'r','LineWidth',1.5)
    title('M2 MPa')
    
end



end
