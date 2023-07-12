function [K, F] = fem_quarterwave_linear(n, d, nelem, nodes_per_elem)
% Compute FEM matrices and vectors for a quarter-wave stack
% with linear expansion functions (m=1)
% Input:
%   n: refractive index of the layer
%   d: thickness of the layer
%   nelem: number of elements per quarter-wave layer
%   nodes_per_elem: number of nodes per element
% Output:
%   K: global stiffness matrix
%   F: global load vector

% Define element stiffness matrix
B = [-1/d, 1/d; -1/d, 1/d];
D = [n^2, 0; 0, 1];
Ke = (B'*D*B)*d/2;

% Define element load vector (zero for interior elements)
Fe = zeros(nodes_per_elem, 1);
if strcmp('dirichlet', left_bc)
    Fe(1) = 0;
elseif strcmp('neumann', left_bc)
    Fe(1) = -1i*n;
end
if strcmp('dirichlet', right_bc)
    Fe(nodes_per_elem) = 0;
elseif strcmp('neumann', right_bc)
    Fe(nodes_per_elem) = 1i;
end

% Assemble global stiffness matrix and load vector
K = zeros((nelem+1)*nodes_per_elem);
F = zeros((nelem+1)*nodes_per_elem, 1);
for i = 1:nelem
    K((i-1)*nodes_per_elem+1:i*nodes_per_elem, (i-1)*nodes_per_elem+1:i*nodes_per_elem) = K((i-1)*nodes_per_elem+1:i*nodes_per_elem, (i-1)*nodes_per_elem+1:i*nodes_per_elem) + Ke;
    F((i-1)*nodes_per_elem+1:i*nodes_per_elem) = F((i-1)*nodes_per_elem+1:i*nodes_per_elem) + Fe;
end

% Apply boundary conditions (left and right ends)
if strcmp('dirichlet', left_bc)
    K(1,:) = 0;
    K(1,1) = 1;
    F(1) = 0;
elseif strcmp('neumann', left_bc)
    K(1,:) = K(1,:) - 1i*n*Ke(1,:);
    F(1) = -1i*n;
end
if strcmp('dirichlet', right_bc)
    K(end,:) = 0;
    K(end,end) = 1;
    F(end) = 0;
elseif strcmp('neumann', right_bc)
    K(end,:) = K(end,:) + 1i*Ke(end,:);
    F(end) = 1i;
end
end
