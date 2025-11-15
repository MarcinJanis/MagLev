%%
% ========================================================
%                   Distance sensor
% ========================================================
%      Measurements [V] -> Distance [m]



% Measurements [V]
Measurement_V = [8.2;7.9;7.5;7;6.47;5.87;5.22;4.5;3.81;3.03;2.19;1.27;0.30;-0.70;-1.62;-2.53;-3.45;-4.22;-4.99;-5.62;-6.19;-6.70;-7.12;-7.46;-7.71;-7.93;-8.07;-8.15;-8.20];

Measurement_size = size(scale_VtoM_x,1);

Measurement_x = 0:0.0007:(0.0007*(scale_VtoM_size-1));

% Function interpolation
% Polynomianl, 5th degree
fitModel1 = fit(Measurement_V, Measurement_x', 'poly5');
a1 = fitModel1.p1;
b1 = fitModel1.p2;
c1 = fitModel1.p3;
d1 = fitModel1.p4;
e1 = fitModel1.p5;
f1 = fitModel1.p6;

fcn1 = @(x) a1*x.^5 + b1*x.^4 + c1*x.^3 + d1*x.^2 + e1*x + f1;
Measurement_x_check_1 = fcn1(Measurement_V); % Check 


% Polynomianl, 5th degree
fitModel2 = fit(Measurement_V, Measurement_x', 'poly6');
a2 = fitModel2.p1;
b2 = fitModel2.p2;
c2 = fitModel2.p3;
d2 = fitModel2.p4;
e2 = fitModel2.p5;
f2 = fitModel2.p6;
g2 = fitModel2.p7;

fcn2 = @(x) a2*x.^6 + b2*x.^5 + c2*x.^4 + d2*x.^3 + e2*x.^2 + f2*x + g2;
Measurement_x_check_2 = fcn2(Measurement_V); % Check 



figure(1)
plot(Measurement_V, Measurement_x, 'b*-')
hold on
plot(Measurement_V, Measurement_x_check_1, 'r-')
plot(Measurement_V, Measurement_x_check_2, 'g-')
hold off
grid minor
xlabel('Voltage [V]');
ylabel('Distance [m]');
legend('Measurements', 'Interpolation (poly5)', 'Interpolation (poly6)')
title('Voltage to Distance Scaling');

disp('=== Interpolation of measurements ===')
disp('Function:\n x - Distance [m]\n v - Measurement [V]\nx = fcn(v)')
disp(' -- Interpolation: polynomial, 5 degree: --')
disp('fcn = a*x.^5 + b*x.^4 + c*x.^3 + d*x.^2 + e*x + f')
disp(['a = ', num2str(a1)])
disp(['b = ', num2str(b1)])
disp(['c = ', num2str(c1)])
disp(['d = ', num2str(d1)])
disp(['e = ', num2str(e1)])
disp(['f = ', num2str(f1)])
disp(' -- Interpolation: polynomial, 6 degree: --')
disp('fcn = a2*x.^6 + b2*x.^5 + c2*x.^4 + d2*x.^3 + e2*x.^2 + f2*x + g2')
disp(['a = ', num2str(a2)])
disp(['b = ', num2str(b2)])
disp(['c = ', num2str(c2)])
disp(['d = ', num2str(d2)])
disp(['e = ', num2str(e2)])
disp(['f = ', num2str(f2)])
disp(['g = ', num2str(g2)])
disp('------')

