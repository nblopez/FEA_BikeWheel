function [nodemap, glob_coord] = node_mapper(spoke, rim, hub)

% Node 1 is hub center
% Node 2 is assumed to be directly below

nodemap = zeros(spoke.count + rim.elem_count, 3);
spoke_angle_spacing = 2 * pi / spoke.count;
node_angle_spacing = spoke_angle_spacing / 2;

switch spoke.pattern
    
    case 'radial'
        for spoke_node = 1:spoke.count
            % Every other node has spoke connected
            nodemap(spoke_node, :) = [1, 2*spoke_node, 0];
            % Rim element mapping
            rim_elem_num = spoke_node + spoke.count;
            nodemap(rim_elem_num, :) = [2*spoke_node - 1, 2*spoke_node, 2*spoke_node + 1];
        end
        nodemap(spoke.count + 1,:) = [max(max(nodemap)), 2, 3]; 
        
        
        glob_coord = zeros(2, max(max(nodemap)));

        for node = 2:length(glob_coord)
            node_angle = node_angle_spacing * (node - 2); % 0 rad at node 2
            X = spoke.length * sin(node_angle);
            Y = -spoke.length * cos(node_angle);
            
            glob_coord(:, node) = [X; Y];
        end
        
        
               
    case '1-cross'
        
        
        
    case '2-cross'
        
        
        
        
        
        
end

% glob_coord = 0;