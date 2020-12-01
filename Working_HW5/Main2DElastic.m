% Main script for solving the 2D Elastic example problem (AE420 - Chapt 6)

% Set material properties
E = 100e3; %Units are correct
nu = 0.3;

% For plane strain, E constitutuve matrix
E = E / ((1 + nu) * (1 - 2 * nu)) * [1 - nu, nu, 0;...
                                    nu, 1-nu, 0;...
                                    0, 0, (1- 2 * nu) / 2];
                                
% Define mesh and geometry (nodal coordinates)
ne = 5;
nnodes = 10;

wy = 3; %kN/mm
wx = 1; %kN/mm

X = [0, 3.33, 9.99, 0,   3.33, 6.66, 0, 3.33, 6.66, 9.99];
Y = [5, 5,    5,  2.5, 2.5,  2.5,  0, 0,    0,    0];

nodemap = [2, 1, 4, 5;...  % element 1
           3, 2, 5, 6;...  % element 2
           5, 4, 7, 8;...  % element 3
           6, 5, 8, 9;...  % element 4
           3, 6, 9, 10];   % element 5


% ----- Calculate Shape Functions At Top-Level for Speed -----%       
global eta
global zeta
syms zeta eta
assume([zeta, eta], 'Real')
N1 = (1 + zeta) * (1 + eta) / 4;
N2 = (1 - zeta) * (1 + eta) / 4;
N3 = (1 - zeta) * (1 - eta) / 4;
N4 = (1 + zeta) * (1 - eta) / 4;
N_func = [N1, N2, N3, N4];
N_diff = [diff(N_func, zeta); diff(N_func, eta)];
% ----- End Shape Function Calc -----%

K = K_assembly(ne, nnodes, X, Y, E, nodemap, N_func, N_diff);

% % Define global force vector
F = zeros(2*nnodes, 1);

F(2) = wy * (X(2) - X(1)) / 2;
F(4) = wy * (X(2) - X(1)) / 2 + wy * (X(3) - X(2))/2;
F(5) = 1.6;
F(6) = wy * (X(3) - X(2))/2;
F(19) = 0.4;

alldofs = 1:2*nnodes;
fixeddofs = [1, 7, 13, 14, 16, 18, 20];
freedofs = setdiff(alldofs, fixeddofs);

% Solve for unknown displacements
U = zeros(2*nnodes, 1);
U(freedofs) = K(freedofs,freedofs)\F(freedofs);

% Solve for stresses
[s_xx, s_yy] = StressCalc(X, Y, U, E, N_func, N_diff, nodemap);

% Output Data
node_def = table([1:nnodes]', U(1:2:end), U(2:2:end),...
    'VariableNames', {'Node Number', 'X Def [mm]', 'Y Def [mm]'})

conn_array = [3; 6; 9; 10];
el5_stress = table(conn_array, s_xx, s_yy,...
     'VariableNames', {'Associated Node', 's_xx [MPa]', 's_yy [MPa]'})

PlotStructure(X, Y, U, nodemap);


