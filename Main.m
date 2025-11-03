%% ========================================================================
%  1. ŁADOWANIE DANYCH POMIAROWYCH I SKALOWANIE
%  ========================================================================
%  Ta sekcja wczytuje surowe dane pomiarowe indukcyjności (L)
%  i tworzy odpowiadający im wektor pozycji (x).
% ------------------------------------------------------------------------

L_pomiar = [141.9; 135.3; 130.3; 127; 123.9; 121.6; 119.7; 118.1; ...
            116.7; 115.5; 114.5; 113.6; 112.8; 112; 111.5; 110.9; ...
            110.6; 109.9; 109.5; 109.1; 108.8; 108.5; 108.2; 107.8; ...
            107.6; 107.4] * 0.001;  % Skalowanie z [mH] (prawdopodobnie) do [H]

L_size = numel(L_pomiar); % Liczba punktów pomiarowych
dx = 0.0007; % Krok pomiarowy [m]
x_pomiar = (0:dx:(dx * (L_size - 1)))';  % Wektor pozycji [m]

%% ========================================================================
%  2. MODELOWANIE INDUKCYJNOŚCI L(x)
%  ========================================================================
%  Dopasowujemy model analityczny (podwójna funkcja wykładnicza)
%  do dyskretnych danych pomiarowych L(x). Pozwala to na uzyskanie
%  ciągłych funkcji L(x) i jej pochodnej dL/dx(x).
% ------------------------------------------------------------------------

% Dopasowanie modelu 'exp2': L(x) = a*exp(b*x) + c*exp(d*x)
fitModel_L = fit(x_pomiar, L_pomiar, 'exp2');
disp('Model dopasowania L(x):');
disp(fitModel_L);

% Zapisanie współczynników modelu
a = fitModel_L.a;
b = fitModel_L.b;
c = fitModel_L.c;
d = fitModel_L.d;

% Utworzenie uchwytów (funkcji anonimowych) dla L(x) i dL/dx(x)
L_fun    = @(x) a*exp(b*x) + c*exp(d*x);
dLdx_fun = @(x) a*b*exp(b*x) + c*d*exp(d*x); % Analityczna pochodna

% --- Wizualizacja dopasowania ---
figure;
subplot(2,1,1);
plot(x_pomiar, L_pomiar, 'bo', 'DisplayName', 'Dane pomiarowe');
hold on;
plot(x_pomiar, L_fun(x_pomiar), 'r-', 'LineWidth', 1.5, 'DisplayName', 'Dopasowanie exp2');
hold off;
xlabel('Pozycja x [m]');
ylabel('Indukcyjność L(x) [H]');
title('Dopasowanie funkcji L(x)');
legend show; grid on;

subplot(2,1,2);
plot(x_pomiar, dLdx_fun(x_pomiar), 'g-', 'LineWidth', 1.5);
xlabel('Pozycja x [m]');
ylabel('Pochodna dL/dx [H/m]');
title('Pochodna dL/dx dopasowanej funkcji');
grid on;

%% ========================================================================
%  3. PARAMETRY FIZYCZNE I WARUNKI POCZĄTKOWE
%  ========================================================================

% --- Parametry fizyczne układu ---
m  = 0.058;    % Masa obiektu lewitującego [kg]
R  = 3.9924;   % Rezystancja cewki [Ohm]
u0 = 11.3;     % Napięcie nominalne  [V]
g  = 9.81;     % Przyspieszenie ziemskie [m/s^2]

% --- Warunki początkowe symulacji ---
x0 = 0.02;     % Pozycja początkowa [m]
v0 = 0;        % Prędkość początkowa [m/s]
i0 = 0.0;      % Prąd początkowy [A]
s0 = [x0; v0; i0]; % Wektor stanu początkowego [x; v; i]

% --- Definicja napięcia zasilania w czasie ---
u_supply = @(t) 0.5 * u0;
% u_supply = @(t) 0.5 * u0 * sin(t); 

%% ========================================================================
%  4. RÓWNANIA DYNAMICZNE UKŁADU (MODEL NIELINIOWY)
%  ========================================================================
%  Definiujemy układ równań różniczkowych (postać stanowa)
%  s = [x; v; i], gdzie s' = f(t, s)
%
%  s(1) = x  (pozycja)
%  s(2) = v  (prędkość)
%  s(3) = i  (prąd)
%
%  Równania:
%  1) dx/dt = v
%  2) m*dv/dt = F_em + F_g  => dv/dt = (1/m) * (F_em + F_g)
%     F_em = 0.5 * dL/dx * i^2   (Siła elektromagnetyczna)
%     F_g  = m*g                 (Siła grawitacji)
%     => dv/dt = (0.5/m) * dLdx(x) * i^2 + g
%  3) u = R*i + d(L(x)*i)/dt = R*i + (dL/dx)*(dx/dt)*i + L(x)*(di/dt)
%     u = R*i + dLdx(x) * v * i + L(x) * (di/dt)
%     => di/dt = (u - R*i - dLdx(x)*v*i) / L(x)
% ------------------------------------------------------------------------

f_dynamic = @(t,s) [ ...
    s(2);                                                     % 1) dx/dt = v
    (0.5/m) * dLdx_fun(s(1)) * s(3)^2 - g;                    % 2) dv/dt
    (u_supply(t) - R*s(3) - dLdx_fun(s(1))*s(2)*s(3)) / L_fun(s(1)) % 3) di/dt
];

%% ========================================================================
%  5. SYMULACJA DYNAMICZNA
%  ========================================================================
%  Rozwiązujemy zdefiniowany układ równań różniczkowych
%  używając solwera 'ode15s' (dobrego dla problemów sztywnych).
% ------------------------------------------------------------------------

[t, S] = ode15s(f_dynamic, [0 10], s0); % Symulacja od 0 do 10 sekund


%% ========================================================================
%  6. WIZUALIZACJA WYNIKÓW SYMULACJI
%  ========================================================================

figure;
sgtitle('Wyniki symulacji dynamicznej'); % Tytuł nadrzędny

subplot(3,1,1);
plot(t, S(:,1), 'b', 'LineWidth', 1.5);
ylabel('Pozycja x [m]');
grid on;

subplot(3,1,2);
plot(t, S(:,2), 'r', 'LineWidth', 1.5);
ylabel('Prędkość v [m/s]');
grid on;

subplot(3,1,3);
plot(t, S(:,3), 'g', 'LineWidth', 1.5);
ylabel('Prąd i [A]');
xlabel('Czas t [s]');
grid on;

%% ========================================================================
%  7. ANALIZA STABILNYCH PUNKTÓW PRACY (RÓWNOWAGI)
%  ========================================================================
%  Szukamy zależności między pozycją równowagi (x) a napięciem (u),
%  które jest potrzebne do utrzymania tej pozycji.
% ------------------------------------------------------------------------

% Definiujemy zakres pozycji, dla których szukamy punktów równowagi
x_range = (0.001:0.001:0.02)'; % Zakres x [m]
u_stable_vec = zeros(size(x_range)); % Wektor na wyniki napięć

% Obliczanie napiecia stablinego dla zadnago położenia
for k = 1:numel(x_range)
    % Dla każdego x z badanego zakresu (x_k) obliczamy dL/dx:
    x_k = x_range(k);
    dLdx_k = dLdx_fun(x_k);
    % ============================================
    % równania: 
    % v' = (i^2 * dLdx * / 2m) - mg
    % i' = (u - Ri - dLdx*v*i)/L
    % dla punktu równowagi: v = x' = 0, v' = 0, i' = 0. 
    % Po uwzględnieniu w powyższych równaniach otrzymujemy zależność:
    % Dla każdego x z badanego zakresu: 
    % u_stab = sqrt(2*m*g*R^2/dLdx)
    % ============================================

    if dLdx_k >= 0 % pochdna większa od zera (pod pierwiastkiem)
        u_stable_vec(k) = NaN; % Niemożliwa stabilizacja
    else
        % Obliczenie prądu równowagi
        u_stable_vec(k) = sqrt(2 * m * g * R * R/ abs(dLdx_k));
        if u_stable_vec(k) > u0 
            u_stable_vec(k) = NaN % Jeśli napięcie stabilne większe od maksymalnego możliwego 
        end
    end
end

% --- Aproksymacja funkcji u_stable(x) ---
% Tworzymy ciągłą funkcję, aby łatwo znaleźć napięcie dla dowolnej pozycji
valid_points = ~isnan(u_stable_vec); % Należy usunąć punkty NaN, które psują dopasowanie
fitModel_U = fit(x_range(valid_points), u_stable_vec(valid_points), 'poly4');

% Zapisanie współczynników i utworzenie funkcji
p1_u = fitModel_U.p1;
p2_u = fitModel_U.p2; 
p3_u = fitModel_U.p3; 
p4_u = fitModel_U.p4; 
p5_u = fitModel_U.p5; 

U_stable_fcn = @(x) p1_u * x.^4 + p2_u * x.^3 + p3_u * x.^2 + p4_u * x + p5_u;

% --- Wizualizacja dopasowania U_stable(x) ---
figure;
plot(x_range, u_stable_vec, 'r.', 'DisplayName', 'Dane obliczone (U = R*sqrt(..))');
hold on;
plot(x_range, U_stable_fcn(x_range), 'g-', 'LineWidth', 1.5, 'DisplayName', 'Dopasowanie exp2');
hold off;
xlabel('Pozycja równowagi x [m]');
ylabel('Napięcie równowagi U [V]');
title('Charakterystyka statyczna: Napięcie vs Pozycja równowagi');
legend show; grid on;

%% ========================================================================
%  8. WYZNACZENIE PUNKTU PRACY DO LINEARYZACJI
%  ========================================================================
%  Wybieramy pożądany punkt pracy (x_stable) i obliczamy
%  odpowiadające mu napięcie (u_stable) i prąd (i_stable).
% ------------------------------------------------------------------------

x_stable = 0.01; % Przykładowa pożądana pozycja równowagi [m]
v_stable = 0;    % W punkcie równowagi prędkość jest zerowa

% Używamy dopasowanej funkcji do znalezienia napięcia
u_stable = U_stable_fcn(x_stable);

% Obliczamy prąd (z prawa Ohma w stanie stacjonarnym)
i_stable = u_stable / R;

% Wektor stanu w punkcie równowagi
s_stable = [x_stable; v_stable; i_stable];

fprintf('\n--- Stabilny Punkt Pracy ---\n');
fprintf('  Pozycja x = %.4f [m]\n', x_stable);
fprintf('  Napięcie U = %.4f [V]\n', u_stable);
fprintf('  Prąd     I = %.4f [A]\n', i_stable);
fprintf('----------------------------\n\n');


%% ========================================================================
%  9. LINEARYZACJA MODELU W PUNKCIE PRACY
%  ========================================================================
%  Obliczamy macierze Jacobiego (A i B) dla zlinearyzowanego
%  modelu stanu: s_dot = A*s + B*u
% ------------------------------------------------------------------------

disp('Rozpoczynanie linearyzacji...');

% zmienne symboliczne
syms x v i u real

% parametry liczbowe
m_s = m;
R_s = R;
g_s = g;

% Definiujemy symbolicznie funkcje L(x) i dL/dx(x)
L_sym = a*exp(b*x) + c*exp(d*x);
dLdx_sym = diff(L_sym, x); % Symboliczne obliczenie pochodnej

% Definiujemy symboliczne równania stanu f(s, u)
f1 = v;
f2 = (0.5/m_s) * dLdx_sym * i^2 - g_s; % Równanie mechaniczne (z -g)
f3 = (u - R_s*i - dLdx_sym*v*i) / L_sym; % Równanie elektryczne

f_sym = [f1; f2; f3]; % Wektor funkcji stanu
s_sym = [x; v; i];   % Wektor zmiennych stanu
u_sym = u;           % Wektor wejść 

% Obliczenie macierzy Jacobiego
% A = df/ds (pochodna f względem wektora stanu s)
A_sym = jacobian(f_sym, s_sym);

% B = df/du (pochodna f względem wektora wejść u)
B_sym = jacobian(f_sym, u_sym);

% Wyświetlenie macierzy symbolicznych (dla wglądu)
fprintf('\nSymboliczna macierz A (Jacobian f wzg. s):\n');
disp(A_sym);
fprintf('\nSymboliczna macierz B (Jacobian f wzg. u):\n');
disp(B_sym);

% Podstawienie wartości liczbowych z punktu pracy (s_stable, u_stable)
% do symbolicznych macierzy A i B
A_num = subs(A_sym, [x, v, i, u], [x_stable, v_stable, i_stable, u_stable]);
B_num = subs(B_sym, [x, v, i, u], [x_stable, v_stable, i_stable, u_stable]);

% Konwersja na macierze numeryczne (typu double)
A = double(A_num);
B = double(B_num);

fprintf('\n--- Zlinearyzowane Macierze Systemu ---\n');
fprintf('Macierz A (w punkcie pracy):\n');
disp(A);
fprintf('Macierz B (w punkcie pracy):\n');
disp(B);

% Można również zdefiniować macierz wyjścia C, np. jeśli mierzymy pozycję
C = [1 0 0]; % y = C*x => y = x
D = 0;       % Macierz przenoszenia


%% LQR: szybki wariant z Q=I, R=I + ładne wykresy

% 1) Wagi
Q = eye(3);
R = 1;             % eye(1) == 1

% 2) Sterowalność i wzmocnienie LQR
Co = ctrb(A,B);
if rank(Co) < size(A,1)
    warning('Uwaga: (A,B) nie jest sterowalne w tym punkcie pracy.');
end
[K, S, e] = lqr(A, B, Q, R);   % S=P (macierz Riccatiego), e=bieguny CL

% 3) Układy do odpowiedzi na odchyłkę i na wejście
Acl = A - B*K;
sys_x = ss(Acl, eye(3), eye(3), zeros(3));     % stany na wyjściu
sys_y = ss(Acl, eye(3), C, zeros(1,3));        % wyjście y = Cx

% 4) Warunek początkowy jako odchyłka od równowagi
x_eq = s_stable(1); v_eq = s_stable(2); i_eq = s_stable(3);
x0_dev = [x0; v0; i0] - [x_eq; v_eq; i_eq];

% 5) Symulacja odpowiedzi na warunek początkowy (model liniowy)
t = linspace(0, 1.5, 1501);     % horyzont i rozdzielczość
[xyz, ~] = initial(sys_x, x0_dev, t);          % [x v i]
[y_lin, ~] = initial(sys_y, x0_dev, t);        % wyjście

% 6) Dodaj poziom równowagi (ładny podgląd w jednostkach rzeczywistych)
x_lin = xyz(:,1) + x_eq;
v_lin = xyz(:,2) + v_eq;
i_lin = xyz(:,3) + i_eq;
y_lin = y_lin     + C*[x_eq; v_eq; i_eq];

% 7) Wykresy
figure('Name','LQR (Q=I, R=I): odpowiedź na warunek początkowy');
tiledlayout(4,1);

nexttile; plot(t, x_lin, 'LineWidth', 1.3); grid on;
ylabel('x [m]'); title('Pozycja');

nexttile; plot(t, v_lin, 'LineWidth', 1.3); grid on;
ylabel('v [m/s]'); title('Prędkość');

nexttile; plot(t, i_lin, 'LineWidth', 1.3); grid on;
ylabel('i [A]'); title('Prąd');

nexttile; plot(t, y_lin, 'LineWidth', 1.3); grid on;
ylabel('y'); xlabel('t [s]'); title('Wyjście (C x)');

% 8) Info diagnostyczne
disp('Wzmocnienie K ='); disp(K);
disp('Bieguny(A-BK) ='); disp(e);
