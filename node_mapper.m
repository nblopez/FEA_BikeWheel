function [nodemap, glob_coord] = node_mapper(spoke, rim)

% Node 1 is hub center
% Node 2 is assumed to be directly below

nodemap = zeros(spoke.count + rim.elem_count, 2);

switch spoke.pattern
    
    case 'radial'
        for spoke_node = 2:spoke.count+1
            nodemap(spoke_node-1, :) = [1, spoke_node];
        end
        
        start_rim_elem = (spoke.count + 1);
        end_rim_elem = (spoke.count + rim.elem_count);
        rim_diff = end_rim_elem - start_rim_elem + 1;
        for rim_elem = start_rim_elem:end_rim_elem
            nodemap(rim_elem, :) = [rim_elem - rim_diff + 1, rim_elem - rim_diff + 2];
        end
        
        nodemap(end,:) = [rim.elem_count+1, 2];
        
        glob_coord = zeros(2, max(max(nodemap)));
        
        spoke_angle_spacing = 2 * pi / spoke.count;
        for node = 2:spoke.count + 1
            spoke_angle = (node - 2) * spoke_angle_spacing;
            glob_coord(1, node) = spoke.length * sin(spoke_angle);
            glob_coord(2, node) = -spoke.length * cos(spoke_angle);
        end
        
        
        
        
    case '1-cross'
        
        
    case '2-cross'
        
        
        
        
        
        
end

% glob_coord = 0;