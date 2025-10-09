%% Scaling x to inductance value

% Data

L = [0.001;0.0006;0.0003;0.0001;0.00005;0.00001]; %Uzupełnić pomiary 

L_size = size(L,1);
x = 0:0.0007:(0.0007*(L_size-1)); x = x';

Diameter = 59.3*0.001; %[m] //Ball diameter 
x = x + 0.5*Diameter;


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


