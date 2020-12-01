% Script for assembling the global stiffness matrix

function Kg = K_assembly(ne, nnodes, X, Y, E, nodemap, N_func, N_diff)

ndof = 2*nnodes; % # of degress of freedom in global structure
Kg = zeros(ndof, ndof); % initialize global stiffness matrix
% (alternative function: "Kg = sparse(ndof, ndof)")

for i = 1:ne
    fprintf('Calculating Stiffness Matrix for Element Number: %d\n', i);
    enodes = nodemap(i, :); % extract nodes from element i
    Xe = X(enodes); % obtain x-coordinates of element i's nodes
    Ye = Y(enodes); % obtain y-coordinates of element i's nodes
    
    ke = Ke2Diso(E, Xe, Ye, N_func, N_diff); % obtain element stiffness matrix
    edof = nodes_to_dofs(enodes);
    
    Kg(edof, edof) = Kg(edof, edof) + ke;
end
end

function el_dofs = nodes_to_dofs(el_nodes)

n = max(size(el_nodes)); % number of nodes is given by the size of the node list
el_dofs = zeros(2*n, 1);

for i = 1:n
    el_dofs(2*i-1) = 2*el_nodes(i) - 1;
    el_dofs(2*i) = 2*el_nodes(i);
end
end

function ke = Ke2Diso(E, Xe, Ye, N_func, N_diff)
global eta
global zeta
thickness = 1;

xe_func = dot(Xe, N_func);
ye_func = dot(Ye, N_func);

J = [diff(xe_func, zeta), diff(ye_func, zeta);...
    diff(xe_func, eta), diff(ye_func, eta)];
J_det = det(J);

dN = J \ N_diff;
dNdx = dN(1, :);
dNdy = dN(2, :);

B = [dNdx(1), 0, dNdx(2), 0, dNdx(3), 0, dNdx(4), 0;...
    0, dNdy(1), 0, dNdy(2), 0, dNdy(3), 0, dNdy(4);...
    dNdy(1), dNdx(1), dNdy(2), dNdx(2), dNdy(3), dNdx(3), dNdy(4), dNdx(4)];

calc_mat = thickness *  B' * E * B * J_det;

% ke = double(thickness * int(int(calc_mat, zeta, -1, 1), eta, -1, 1));
ke = zeros(size(calc_mat));
w = [1/sqrt(3), -1/sqrt(3)];
for ii = 1:2
    for jj = 1:2
        ke = ke + subs(subs(calc_mat, zeta, w(ii)), eta, w(jj));
    end
end
end





