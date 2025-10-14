% %% Parametry
% m = 0.058;           % masa [kg]
% R = 2;               % opór [Ohm] - przykładowa wartość
% u0 = 5;              % napięcie zasilania [V]
% 
% x0 = 0.02;           % pozycja początkowa [m]
% v0 = 0;              % prędkość początkowa [m/s]
% i0 = 0;              % prąd początkowy [A]
% 
% %% Definicja funkcji indukcyjności i jej pochodnej
% % (przykładowe funkcje — dopasuj do swoich danych)
% L    = @(x) 0.1*exp(-50*x) + 0.05;          % [H]
% dLdx = @(x) -50*0.1*exp(-50*x);             % [H/m]
% 
% %% Napięcie zasilania (stałe)
% u = @(t) u0;
% 
% %% Układ równań różniczkowych
% f = @(t,s) [ ...
%     s(2);                                                  % dx/dt = v
%     0.5/m * dLdx(s(1)) * s(3)^2;                           % dv/dt = siła elektromagnetyczna
%    ( u(t) - R*s(3) - dLdx(s(1))*s(2)*s(3) ) / L(s(1)) ];   % di/dt = obwód prądu
% 
% %% Warunki początkowe
% s0 = [x0; v0; i0];
% 
% %% Symulacja
% [t, S] = ode45(f, [0 0.05], s0);   % symulacja 0–0.05 s
% 
% %% Wykresy wyników
% figure;
% subplot(3,1,1);
% plot(t, S(:,1));
% ylabel('x [m]');
% grid on;
% 
% subplot(3,1,2);
% plot(t, S(:,2));
% ylabel('v [m/s]');
% grid on;
% 
% subplot(3,1,3);
% plot(t, S(:,3));
% ylabel('i [A]');
% xlabel('t [s]');
% grid on;




%% --- Skalowanie i dane pomiarowe ---
L = [141.9; 135.3; 130.3; 127; 123.9; 121.6; 119.7; 118.1; ...
     116.7; 115.5; 114.5; 113.6; 112.8; 112; 111.5; 110.9; ...
     110.6; 109.9; 109.5; 109.1; 108.8; 108.5; 108.2; 107.8; ...
     107.6; 107.4]*0.001;  % [H]

L_size = numel(L);
x = (0:0.0007:(0.0007*(L_size-1)))';  % [m]

%% --- Dopasowanie funkcji wykładniczej ---
fitModel = fit(x, L, 'exp2');   % L = a*exp(b*x) + c*exp(d*x)
disp(fitModel);

a = fitModel.a;
b = fitModel.b;
c = fitModel.c;
d = fitModel.d;

% --- Definicje uchwytów funkcji ---
L_fun    = @(xx) a*exp(b*xx) + c*exp(d*xx);
dLdx_fun = @(xx) a*b*exp(b*xx) + c*d*exp(d*xx);

% --- Sprawdzenie dopasowania ---
figure;
plot(x, L, 'bo', 'DisplayName', 'Dane pomiarowe'); hold on;
plot(x, L_fun(x), 'r-', 'LineWidth', 1.5, 'DisplayName', 'Dopasowanie exp2');
xlabel('x [m]'); ylabel('L(x) [H]');
title('Dopasowanie funkcji L(x)');
legend show; grid on;

figure;
plot(x, dLdx_fun(x), 'k-', 'LineWidth', 1.5);
xlabel('x [m]'); ylabel('dL/dx [H/m]');
title('Pochodna dopasowanej funkcji');
grid on;

%% --- Parametry fizyczne ---
m  = 0.058;   % masa [kg]
R  = 2;       % opór [Ohm]
u0 = 5;       % napięcie [V]

%% --- Warunki początkowe ---
x0 = 0.02;    % pozycja [m]
v0 = 0;       % prędkość [m/s]
i0 = 0;       % prąd [A]
s0 = [x0; v0; i0];

%% --- Napięcie zasilania (stałe) ---
u = @(t) u0 *sin(t);

%% --- Równania dynamiczne ---
f = @(t,s) [ ...
    s(2);                                                     % dx/dt = v
    0.5/m * dLdx_fun(s(1)) * s(3)^2;                         % dv/dt
   (u(t) - R*s(3) - dLdx_fun(s(1))*s(2)*s(3)) / L_fun(s(1))  % di/dt
];

%% --- Symulacja ---
[t, S] = ode15s(f, [0 5], s0);

%% --- Wykresy wyników ---
figure;
subplot(3,1,1);
plot(t, S(:,1), 'b', 'LineWidth', 1.5);
ylabel('x [m]');
grid on;
title('Pozycja, prędkość i prąd w funkcji czasu');

subplot(3,1,2);
plot(t, S(:,2), 'r', 'LineWidth', 1.5);
ylabel('v [m/s]');
grid on;

subplot(3,1,3);
plot(t, S(:,3), 'k', 'LineWidth', 1.5);
ylabel('i [A]');
xlabel('t [s]');
grid on;
