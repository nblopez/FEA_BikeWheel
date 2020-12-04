%% main.m 
% This file contains material and node parameters
% as well as required set of functions to run analysis
clc
%% Object Parameters
% Spoke Parameters
spoke = struct();
spoke.material = 'Stainless Steel';
spoke.rho = 7600; %kg/m^3
spoke.E = 190 * 10^9; %Pa
spoke.length = 0.33; %m (330mm)
spoke.diameter = 0.002; %m (2mm)

% Hub Parameters
hub = struct();
hub.material = 'Super Stiff Material';
hub.rho = 0; %Weightless
hub.E = 1e30; %Super stiff
hub.diameter = 0.1; 

% Rim Parameters
rim = struct();
rim.material = 'Aluminum';
rim.rho = 2700; %kg/m^3
rim.E = 70 * 10^9; %Pa
rim.diameter = spoke.length * 2 + hub.diameter; %m
rim.thickness = 0.25; %m


%% Modifiable Parameters
spoke.count = 20;
spoke.pattern = 'radial';
% spoke.pattern = '1-cross';
% spoke.pattern = '2-cross';

% 3 Nodes per element on rim 
rim.elem_count = spoke.count;
rim.node_count = 3 * rim.elem_count;

%% Script Startup Output
fprintf('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n')
fprintf('Beginning of FEA of Bike Wheel\n')
fprintf('Spoke Count: %d\nSpoke Pattern: %s\n',spoke.count, spoke.pattern)
fprintf('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n')
%% Calculate Nodemap and Global Coordinates
[nodemap, glob_coord] = node_mapper(spoke, rim, hub);
nnodes = max(max(nodemap));
% Row 1 of glob_coord is X, Row 2 of glob_coord is Y











%% Deflection Calculation
U = zeros(nnodes*2, 1); %2DoF per node
U(4) = 1;


%% Analysis Outputs
fprintf('Node Map; Nodes of value 0 do not exist.\n')
disp(nodemap)

fprintf('Global Coordinates; [X, Y]^T\n')
disp(glob_coord)


fprintf('Node Deformation Array;\nNumber, X [mm], Y [mm]\n')
node_def = [[1:nnodes]', [U(1:2:end) * 1e3, U(2:2:end) * 1e3]];
disp(node_def)

[max_def_row, ~] = ind2sub(size(node_def), find(node_def == max(max(node_def))));
fprintf('Maximum deflection occurs at node: %d\nDeflections [mm]: X = %0.3f, Y = %0.3f\n', ...
    node_def(max_def_row, 1), node_def(max_def_row, 2), node_def(max_def_row, 3))
    


PlotStructure(spoke, glob_coord, U, nodemap)














