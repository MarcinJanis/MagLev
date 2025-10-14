%% Scaling x to inductance value

% Data

L = [141.9; 135.3; 130.3; 127;123.9; 121.6; 119.7; 118.1; 116.7; 115.5; 114.5; 113.6; 112.8; 112; 111.5; 110.9; 110.6; 109.9; 109.5; 109.1; 108.8;108.5; 108.2; 107.8; 107.6; 107.4]*0.001; %Uzupełnić pomiary 

L_size = size(L,1);
x = 0:0.0007:(0.0007*(L_size-1)); x = x';

Diameter = 59.3*0.001; %[m] //Ball diameter 
% x = x + 0.5*Diameter;


dLdx = zeros(size(L)); 

% Numerical derivative - ends 
dLdx(1) = (L(2) - L(1)) / (x(2) - x(1));
dLdx(end) = (L(end) - L(end-1)) / (x(end) - x(end-1));

% Numerical derivative - rest of the points
for i = 2:length(L)-1
    dLdx(i) = (L(i+1) - L(i-1)) / (x(i+1) - x(i-1));
end

% Wykres
figure(1);
plot(x, L, 'b-');
grid on
xlabel('x [m]');
ylabel('L(x) [H]');

figure(2);
plot(x, dLdx, 'b-');
grid on
xlabel('x [m]');
ylabel('dL(x)/dx [H/m]');


% % --- Dopasowanie funkcji wykładniczej L = a*exp(b*x)
% f = fit(x, L, 'exp2');
% dfdx = diff(f,x)
% 
% % --- Wyniki ---
% disp(f)
% 
% % --- Wykres aproksymacji ---
% figure(3);
% plot(f, x, L);
% xlabel('x [m]');
% ylabel('L(x) [H]');
% title('Aproksymacja funkcją wykładniczą');
% grid on;


% --- Dopasowanie ---
f = fit(x, L, 'exp2');
disp(f)

% --- Wyciągnięcie współczynników ---
a = f.a; b = f.b; c = f.c; d = f.d;

% --- Definicja pochodnej ---
dfdx = @(x) a*b*exp(b*x) + c*d*exp(d*x);

% --- Wykres pochodnej dopasowania ---
figure(3);
plot(x, dfdx(x), 'r-', 'LineWidth', 1.5);
grid on;
xlabel('x [m]');
ylabel('dL_fit/dx [H/m]');
title('Pochodna dopasowanej funkcji wykładniczej');
