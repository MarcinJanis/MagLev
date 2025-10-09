%% Identification of resistance


i = [0; 0.145; 0.443; 0.737; 1.035; 1.327; 1.619; 1.907; 2.192; 2.474; 2.72];
u = [0; 0.1; 0.2; 0.3; 0.4; 0.5; 0.6; 0.7; 0.8; 0.9; 1];


% Fit a linear model to the data
fitType = 'poly1'; % Linear polynomial
fitobject = fit(i, u, fitType); % u = i * R + R_0

R = 1/fitobject.p1;
disp(['Resistance: ', num2str(R), ' [Ohm]'])

figure(1)
plot(i,u, 'r*')
legend('Measurements')
hold on 
plot(fitobject, 'b')
hold off
grid on 
xlabel('Voltage [V]');
ylabel('Current [A]');
title('Resistance characteristic');