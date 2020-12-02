%% main.m 
% This file contains material and node parameters
% as well as required set of functions to run analysis

%% Spoke Parameters
spoke = struct();
spoke.material = 'Stainless Steel';
spoke.rho = 7600; %kg/m^3
spoke.E = 190 * 10^9; %Pa
spoke.length = 0.33; %m (330mm)
spoke.diameter = 0.002; %m (2mm)


% Rim Parameters
rim = struct();
rim.material = 'Aluminum';
rim.rho = 2700; %kg/m^3
rim.E = 70 * 10^9; %Pa
rim.diameter = spoke.length * 2; %m
rim.thickness = 0.25; %m

%% Modifiable Parameters
spoke.count = 20; %System is impossible to solve with less than 3 spokes
spoke.pattern = 'radial';
% spoke.pattern = '1-cross';
% spoke.pattern = '2-cross';

rim.elem_count = spoke.count;

[nodemap, glob_coord] = node_mapper(spoke, rim);
% Row 1 of glob_coord is X, Row 2 of glob_coord is Y











%% Deflection Calculation
U = zeros(max(max(nodemap))*2, 1); %2DoF per node



%% Graphical Output
PlotStructure(glob_coord, U, nodemap)

















