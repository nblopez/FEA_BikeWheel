function [nodemap, glob_coord] = node_mapper(spoke, rim, hub)

% Node 1 is hub center
% Node 2 is assumed to be directly below

nodemap = zeros(spoke.count + rim.elem_count, 3);
spoke_angle_spacing = 2 * pi / spoke.count;
node_angle_spacing = spoke_angle_spacing / 2;

for hub_node = 1:spoke.count
    nodemap(hub_node, :) = [hub_node, hub_node + 1, 0];
end
nodemap(spoke.count,:) = [spoke.count, 1, 0];

switch spoke.pattern
    
    case 'radial'
        for spoke_node = 1:spoke.count
            % Every other node has spoke connected
            nodemap(spoke.count + spoke_node, :) = [spoke_node, 2*spoke_node + spoke.count, 0];
            % Rim element mapping
            rim_elem_num = spoke_node + 2 * spoke.count;
            nodemap(rim_elem_num, :) = [2*spoke_node + spoke.count - 1,...
                                        2*spoke_node + spoke.count,...
                                        2*spoke_node + spoke.count + 1];
        end
        nodemap(end,3) = spoke.count + 1; %Set last element to connect to first node of rim
        
        
        glob_coord = zeros(2, max(max(nodemap)));

        for node = 1:length(glob_coord)
            if node <= spoke.count
                node_angle = spoke_angle_spacing * (node - 1); % 0 rad at node 1
                X = hub.diameter / 2 * sin(node_angle);
                Y = -hub.diameter / 2 * cos(node_angle);
            else
                node_angle = node_angle_spacing * (node - spoke.count - 2); % 0 rad at beginning of spokes
                X = (spoke.length + hub.diameter / 2) * sin(node_angle);
                Y = -(spoke.length + hub.diameter / 2) * cos(node_angle);
            end
            glob_coord(:, node) = [X; Y];
            
        end
        
        
               
    case '1-cross'
        
        
        
    case '2-cross'
        
        
        
        
        
        
end

% glob_coord = 0;