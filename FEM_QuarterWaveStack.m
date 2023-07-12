function [R, T] = FEM_QuarterWaveStack(d, n)
% Calculate the reflection and transmission coefficients for a quarter-wave stack using the FEM method
% with linear expansion functions (m=1) and 3 quadratic elements per quarter-wave layer.

% Constants
c = 299792458; % Speed of light in vacuum in m/s

% Input validation
if numel(d) ~= numel(n)
    error('The thickness and refractive index vectors must have the same number of elements.');
end

% Calculation
lambda = linspace(400, 800, 201); % Wavelength range in nm
R = zeros(size(lambda)); % Reflection coefficient
T = zeros(size(lambda)); % Transmission coefficient

for i = 1:numel(lambda)
    k = 2*pi*n.*d./lambda(i); % Wave vector
    K = diag([1, exp(-1i*k(2)), exp(-1i*k(1)), 1]); % Propagation matrix
    M = zeros(4); % System matrix
    M(1:2, 1:2) = [1, -1; -1, 1]; % Boundary condition at the top
    M(3:4, 3:4) = [exp(1i*k(2)), 0; 0, exp(-1i*k(2))]; % Boundary condition at the bottom
    M(2:3, 2:3) = -K(1:2, 1:2); % Layer 1
    M(2:3, 3:4) = -K(1:2, 3:4); % Layer 2
    M(1:2, 2:3) = K(3:4, 1:2); % Layer 2
    M(3:4, 2:3) = K(3:4, 3:4); % Layer 3
    b = [1; 0; 0; 0]; % Input vector
    x = M \ b; % Output vector
    R(i) = abs(x(1))^2; % Reflection coefficient
    T(i) = real(n(end)*cos(asin(n(1)/n(end))) / x(4) * conj(x(3)) * abs(x(1))^2); % Transmission coefficient
end

% Convert units and normalize
R = R / max(R);
T = T / max(T);

end
