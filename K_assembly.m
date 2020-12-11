% Script for assembling the global stiffness matrix
%ne should be a struct containing ne.spokes and ne.rims, same thing with E
function Kg = K_assembly(nnodes, X, Y, spoke, rim, nodemap)
Ne_spoke = spoke.count;
ndof = 2*nnodes; % # of degress of freedom in global structure
Kg = zeros(ndof, ndof); % initialize global stiffness matrix
% (alternative function: "Kg = sparse(ndof, ndof)")
E_spoke = spoke.E;
E_rim = rim.E;
Ae_spoke = spoke.Ae;
Ae_rim = rim.Ae;

for i = Ne_spoke+1:2*Ne_spoke
    
    enodes_spoke = nodemap(i,1:2); % extract nodes from element i
    Xe = X(enodes_spoke); % obtain x-coordinates of element i's nodes
    Ye = Y(enodes_spoke); % obtain y-coordinates of element i's nodes
    
    ke = Ke_Spoke(E_spoke, Ae_spoke, Xe, Ye); % obtain element stiffness matrix
    edof = nodes_to_dofs(enodes_spoke);
    
    Kg(edof, edof) = Kg(edof, edof) + ke;
end

bar_elements = input('Would you like to use bar elements on the rim? [y, n] ', 's');

for j = 2*Ne_spoke+1:length(nodemap)
    
    enodes_rim = nodemap(j, :); % extract nodes from element i
    Xe = X(enodes_rim); % obtain x-coordinates of element i's nodes
    Ye = Y(enodes_rim); % obtain y-coordinates of element i's nodes
    
    if strcmp(bar_elements, 'y')
        ke = Ke_Rim_Truss(E_rim, Ae_rim, Xe, Ye); % obtain element stiffness matrix
    else
        ke = Ke_rim_polar(rim, spoke, Xe, Ye, 0.1);
    end
    edof = nodes_to_dofs(enodes_rim);
    
    Kg(edof, edof) = Kg(edof, edof) + ke;
end

function el_dofs = nodes_to_dofs(el_nodes)

n = max(size(el_nodes)); % number of nodes is given by the size of the node list
el_dofs = zeros(2*n, 1);

for i = 1:n
    el_dofs(2*i-1) = 2*el_nodes(i) - 1;
    el_dofs(2*i) = 2*el_nodes(i);
end