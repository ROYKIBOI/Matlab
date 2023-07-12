%% Parameters
n1 = 1; % Refractive index of medium 1
n2 = 1.5; % Refractive index of medium 2
N = 10; % Number of quarter wave layers
lambda = linspace(400e-9, 700e-9, 1000); % Wavelength range of light
h = lambda/(4*n2); % Thickness of each layer

%% Mesh Generation
x = linspace(0, N*h, 1000); % x-axis
y = linspace(-h/2, h/2, 10); % y-axis
[X, Y] = meshgrid(x, y); % Meshgrid
nodes = [X(:), Y(:)]; % Node coordinates
elements = delaunay(nodes); % Triangulation

%% Material Assignment
materials = zeros(size(elements, 1), 1);
for i = 1:size(elements, 1)
    x1 = nodes(elements(i, 1), 1);
    x2 = nodes(elements(i, 2), 1);
    if mod(x1, h) < mod(x2, h)
        materials(i) = 1; % Layer 1
    else
        materials(i) = 2; % Layer 2
    end
end

%% Solution
k0 = 2*pi./lambda; % Wavenumber in vacuum
k1 = k0*n1; % Wavenumber in medium 1
k2 = k0*n2; % Wavenumber in medium 2
kz1 = sqrt(k1.^2 - (k0./n1).^2); % z-component of k-vector in medium 1
kz2 = sqrt(k2.^2 - (k0./n2).^2); % z-component of k-vector in medium 2
A = zeros(2, 2);
B = zeros(2, 2);
C = zeros(2, 2);
D = zeros(2, 2);
T = zeros(size(lambda));
R = zeros(size(lambda));
for j = 1:length(lambda)
    for i = 1:N
        kz = kz1(j)*sqrt(1 - (kz1(j)/kz2(j))^2); % z-component of k-vector in layer i
        q = 1i*kz;
        Q = [1/q, 1; q, 1/q]; % Transfer matrix
        A = A*Q;
        B = B*Q;
        C = C*Q;
        D = D*Q;
    end
    T(j) = 1/abs(D(1, 1))^2; % Transmittance
    R(j) = abs((A(1, 1)*n1 - A(1, 2)*n2)/(A(1, 1)*n1 + A(1, 2)*n2))^2; % Reflectance
end

%% Plotting
figure;
plot(x, materials, 'k', 'LineWidth', 2); % Material plot
xlabel('Position (m)');
ylabel('Material');
ylim([0.5, 2.5]);
yticks([1, 2]);
yticklabels({'Layer 1', 'Layer 2'});
title('Dielectric Mirror');

figure;
plot(lambda*1e9, T, 'r', 'LineWidth', 2); % Transmittance plot
hold on;
plot(lambda*1e9, R, 'b', 'LineWidth', 2); % Reflectance plot
xlabel('Wavelength (nm)');
ylabel('Transmittance/Reflectance');
title('Dielectric Mirror');
legend('Transmittance', 'Reflectance');
