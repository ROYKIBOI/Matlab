% Define parameters
epsilon_r = 2; % Relative permittivity of dielectric rod
a = 0.1; % Radius of circular field
lambda = 1; % Wavelength of incident field
k = 2*pi/lambda; % Wave vector
N = 50; % Number of ripples to include in plot

% Define FEM Grid
x = linspace(-a,a,1000);
y = linspace(-a,a,1000);
[X,Y] = meshgrid(x,y);
r = sqrt(X.^2 + Y.^2);

% Calculate electric field
E = k*(1 + epsilon_r)*(a^2./r.^3).*cos(k*r);

% Plot magnitude of electric field
figure;
hold on;
theta = linspace(0,2*pi,1000);
for n = 1:N
    plot(a*cos(theta),a*sin(theta),'r--');
    a = a + 0.1*a;
end
circ = plot(a*cos(theta),a*sin(theta),'k-');
set(circ,'LineWidth',2);
colormap('hot');
imagesc(x,y,abs(E));
axis equal;
axis([-a a -a a]);
colorbar;
title('Magnitude of Electric Field for Dielectric Rod');
xlabel('x');
ylabel('y');
set(gca,'color','r');
