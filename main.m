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
spoke.length = 0.300; %m (300mm)
spoke.diameter = 0.002; %m (2mm)
spoke.Ae = pi * spoke.diameter^2 / 4; %m^2

% Hub Parameters
hub = struct();
hub.material = 'Super Stiff Material';
hub.diameter = 0.1;

% Rim Parameters
rim = struct();
rim.material = 'Aluminum';
rim.rho = 2700; %kg/m^3
rim.E = 70 * 10^9; %Pa
rim.diameter = spoke.length * 2 + hub.diameter; %m
rim.depth = 0.025; %m, Depth into screen
rim.thickness = 0.005; %m, Radial thickness
rim.Ae = rim.depth * rim.thickness; %m^2


%% Modifiable Parameters
spoke.count = 12;
% spoke.pattern = 'radial'; %Minimum 3 spokes
% spoke.pattern = '1-cross'; %Minimum 6 spokes (Even Number Only)
spoke.pattern = '2-cross'; %Minimum 12 spokes (Even Number Only)
% spoke.pattern = '3-cross'; %Minimum 18 spokes (Even Number Only)
% 3 Nodes per element on rim
rim.elem_count = spoke.count;
rim.node_count = 2 * rim.elem_count;

%% Script Startup Output
fprintf('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n')
fprintf('Beginning of FEA of Bike Wheel\n')
fprintf('Spoke Count: %d\nSpoke Pattern: %s\n',spoke.count, spoke.pattern)
fprintf('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n')
%% Calculate Nodemap and Global Coordinates
[nodemap, glob_coord] = node_mapper(spoke, rim, hub);
nnodes = max(max(nodemap));
% remove_spoke = input('Would you like to simulate a broken spoke? [y, n] ', 's');
remove_spoke ='n';
if strcmp(remove_spoke, 'y')
    lower_spoke = input('Would you like to remove the lower or upper spoke? [l, u] ', 's');
    if strcmp(lower_spoke, 'l')
        rem_spoke = find(nodemap(:,2) == spoke.count + 2, 1, 'first');
    else
        rem_spoke = find(nodemap(:,2) == rim.node_count - spoke.count + 2, 1, 'first');
    end
    node_list = 1:nnodes;
    nodemap = nodemap(setdiff(node_list, rem_spoke), :);
end
% Row 1 of glob_coord is X, Row 2 of glob_coord is Y











%% Deflection Calculation
%Inputs spoke count, number of nodes, X coord, Y coord, spoke params, rim
%params, nodemap
K_global = K_assembly(nnodes, glob_coord(1,:), glob_coord(2,:), spoke, rim, nodemap);

%Outputs global stiffness matrix
%Currently outputs a bunch of zeros but it is to the power E10 so hopefully
%when we solve we actually get something

alldofs = 1:2*nnodes;
fixeddofs = 1:2*spoke.count;
freedofs = setdiff(alldofs, fixeddofs);

F = zeros(2*nnodes, 1);
F_load = 300; %N
F(2*spoke.count + 4) = F_load; %Vertical Load at lowest node on rim

U = zeros(2*nnodes, 1); %2DoF per node
K_reduced = K_global(freedofs, freedofs);
U(freedofs) = K_reduced \ F(freedofs);




%% Analysis Outputs
print_details = input('Would you like to print fine details? [y, n] ', 's');
if strcmp(print_details, 'y')
    fprintf('Node Map; Nodes of value 0 do not exist.\n')
    disp(nodemap)
    
    fprintf('Global Coordinates; [X, Y]^T\n')
    disp(glob_coord)
    
    
    fprintf('Node Deformation Array;\nNumber, X [mm], Y [mm]\n')
    node_def = [[1:nnodes]', U(1:2:end) * 1e3, U(2:2:end) * 1e3];
    disp(node_def)
    
    
    [max_def_row, ~] = ind2sub(size(node_def), find(node_def == max(max(node_def))));
    fprintf('Maximum deflection occurs at node: %d\nDeflections [mm]: X = %0.3f, Y = %0.3f\n', ...
        node_def(max_def_row, 1), node_def(max_def_row, 2), node_def(max_def_row, 3))
    
end

PlotStructure(spoke, glob_coord, U, nodemap)














