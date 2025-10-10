%% Model parameters

%% Scaling voltage to meters

% create lookup table based on following vectors
% u [Voltage] -> | scale_VtoM_x | scale_VtoM_y | -> x [meters]
scale_VtoM_x = [8.2;7.9;7.5;7;6.47;5.87;5.22;4.5;3.81;3.03;2.19;1.27;0.30;-0.70;-1.62;-2.53;-3.45;-4.22;-4.99;-5.62;-6.19;-6.70;-7.12;-7.46;-7.71;-7.93;-8.07;-8.15;-8.20];
scale_VtoM_size = size(scale_VtoM_x,1);
scale_VtoM_y = 0:0.0007:(0.0007*(scale_VtoM_size-1)); scale_VtoM_y = scale_VtoM_y';

%% Scaling ... to current

%% Inductance


%% Parameters

% Mechanical
M = 0.058; %[kg]
Diameter = 59.3*0.001; %[m]

% Electrical
R = 3.9924; % [Ohm]
u_max = 11.3; % [V]
% f_PWM = [Hx];
