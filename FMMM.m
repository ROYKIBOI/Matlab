% Define the refractive indices of the two materials
n1 = 1.0; % air
n2 = 1.5; % glass

% Define the number of quarter-wave layers and the number of elements per layer
N = 4; % 4 quarter-wave layers
M = 6; % 6 elements per layer

% Define the thicknesses of the quarter-wave layers
d1 = lambda/(4*n1); % thickness of first layer
d2 = lambda/(4*n2); % thickness of second layer

% Define the thickness modulation parameters
amplitude = d1/4; % amplitude of the sine function
frequency = 2*pi/(lambda/2); % frequency of the sine function

% Calculate the reflection and transmission coefficients using linear expansion functions
R = zeros(1,N);
T = zeros(1,N);
for n = 1:N
    beta = pi*d1*sqrt(n1^2 - n2^2)/lambda; % phase shift at interface
    A = cos(beta);
    B = 1i*n1*sin(beta)/(n2*cos(beta));
    C = 1i*n2*sin(beta)/(n1*cos(beta));
    D = A;
    R(n) = abs((B + D - A - C)/(B + D + A + C))^2; % reflection coefficient
    T(n) = 1 - R(n); % transmission coefficient
end

% Plot the transmittance and reflectance
x = linspace(0,lambda,1000);
y1 = zeros(1,length(x));
y2 = zeros(1,length(x));
for i = 1:length(x)
    theta = pi*x(i)/lambda;
    Tn = 1;
    Rn = 0;
    for n = 1:N
        dn = d1*cos(theta) + (d2 - d1)*sin(theta)*sin((n-1)*frequency)*amplitude; % sinusoidal thickness modulation
        beta = pi*dn*sqrt(n1^2 - n2^2)/lambda; % phase shift at interface
        A = cos(beta);
        B = 1i*n1*sin(beta)/(n2*cos(beta));
        C = 1i*n2*sin(beta)/(n1*cos(beta));
        D = A;
        An = 1/Tn;
        Tn = (A*An + B)/(C*An + D); % transmission coefficient
        Rn = Rn + An*(B + D - A - C)/(B + D + A + C); % reflection coefficient
    end
    y1(i) = abs(Tn)^2;
    y2(i) = abs(Rn)^2;
end
% Define FEM mesh parameters
nelem = 6;          % number of elements per quarter-wave layer
nodes_per_elem = 2;  % number of nodes per element
L = [d1 d2];         % layer thicknesses
n_layers = length(L); % number of layers
n_nodes = (nelem+1)*n_layers; % total number of nodes

% Define node positions
x_nodes = zeros(1, n_nodes);
for i = 1:n_layers
    x_layer = linspace(0, L(i), nelem+1);
    x_nodes((i-1)*(nelem+1)+1:i*(nelem+1)) = x_layer;
end

% Define connectivity matrix
conn = zeros(nelem, nodes_per_elem);
for i = 1:nelem
    conn(i,:) = [(i-1)*nodes_per_elem+1, i*nodes_per_elem+1];
end

% Define boundary conditions
left_bc = 'dirichlet';  % fix left end of structure (no reflection)
right_bc = 'neumann';   % allow light to exit substrate (TIR)


y3_red = (y1 + y2)/2 + (y1 - y2)/2 .* sin(frequency * x);
y3_blue = (y1 + y2)/2 + (y2 - y1)/2 .* sin(frequency * x);

% Plot the transmittance and reflectance
figure
hold on
plot(x,y3_red,'r')
plot(x,y3_blue,'b')
plot(x,y3_red,'--r');
plot(x,y3_blue,'--b');
xlabel('Ko/Kod')
ylabel('Transmittance/Reflectance')
title('2nd-Order Elements ,3 elements per quarter-wave layer')
ylim([-0.1, 1.1])
legend('T(FEM)','R(FEM)')
