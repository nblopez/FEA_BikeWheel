function [sig_xx, sig_yy] = CalcStress(spoke, rim, X, Y, U, N_func, N_diff, nodemap)

    map_hub = nodemap(1:spoke.count,1:2);  % separating hub elements
    
    map_spoke =  nodemap(spoke.count+1:2*spoke.count,1:2);  % separating spoke elements
    
    map_rim = nodemap(2*spoke.count+1:end,1:3) ; % separating rim elements
    
    num_nodes = max(max(nodemap));
    
    sig_xx = zeros(num_nodes,1);        
    sig_yy = zeros(num_nodes,1); 
    
    
    
    [ sig_xx(map_spoke(:,1)) , sig_yy(map_spoke(:,1))] = [ sig_xx(map_spoke(:,1)) , sig_yy(map_spoke(:,1))]+spoke_Stress(spoke, U, map_spoke);
    [ sig_xx(map_spoke(:,2)) , sig_yy(map_spoke(:,2))] = [ sig_xx(map_spoke(:,2)) , sig_yy(map_spoke(:,2))]+spoke_Stress(spoke, U, map_spoke);
    
    [ sig_xx(map_rim(:,1)) , sig_yy(map_rim(:,1))] = [ sig_xx(map_rim(:,1)) , sig_yy(map_rim(:,1))]+rim_Stress(rim, X, Y, U, N_func, N_diff, map_rim);
    [ sig_xx(map_rim(:,2)) , sig_yy(map_rim(:,2))] = [ sig_xx(map_rim(:,2)) , sig_yy(map_rim(:,2))]+rim_Stress(rim, X, Y, U, N_func, N_diff, map_rim);
    [ sig_xx(map_rim(:,3)) , sig_yy(map_rim(:,3))] = [ sig_xx(map_rim(:,3)) , sig_yy(map_rim(:,3))]+rim_Stress(rim, X, Y, U, N_func, N_diff, map_rim);
    
    
end



function [sig_xx, sig_yy] = spoke_Stress(spoke, U, spoke_nodemap)
    
    l = spoke.length;
    sig_xx = spoke.E*(U(2*spoke_nodemap(:,1)-1)-U(2*spoke_nodemap(:,2)-1))/l;
    sig_yy = spoke.E*(U(2*spoke_nodemap(:,1))-U(2*spoke_nodemap(:,2)))/l;

end


function [sig_xx, sig_yy] = rim_Stress(rim, X, Y, U, map_rim)
    

    start_angle = atan(Ye(2) / Xe(2));
    r = rim.diameter / 2;
    d_theta = 2 * pi / (spoke.count);
    
    theta_arr = [-d_theta/2, 0, d_theta/2] + ang_offset + start_angle;
    Le = r*d_theta;

    syms S
    assume(S, 'Real')
    N1 = 2*S^2/Le^2 - 3*S/Le + 1;
    N2 = -4*S^2/Le^2 + 4*S/Le;
    N3 = 2*S^2/Le^2 - S/Le;
    
    N_mat = [N1, N2, N3];
    N_diff = diff(N_mat, S);

    rt_func = r * dot(theta_arr, N_mat);

    J = diff(rt_func, S);
    J_det = det(J); 

    dN = J \ N_diff;
    dNdx = dN * 1 ./ cos(theta_arr);
    dNdy = dN * 1 ./ sin(theta_arr);

    E_rim = [rim.E 0 0;0 rim.E 0; 0 0 0.33*rim.E];
    
    %Solve for derivitive wrt 
    
    B = [   dNdx(1),           0,    dNdx(2),          0,   dNdx(3),         0    ;...
                  0,     dNdy(1),          0,    dNdy(2),         0,    dNdy(3)   ;...
            dNdy(1),     dNdx(1),    dNdy(2),    dNdx(2),   dNdy(3),    dNdx(3)  ];
    
    n_rim = size(map_rim);
    n_rim = n_rim(1);
    sig_xx = [];
    sig_yy = [];
    for i = 1:n_rim  
        [sig_x,sig_y,] =  E*B*U(map_rim(i,:));                     % stress calculation
        [sig_xx, sig_yy] = [sig_xx, sig_yy ; sig_x , sig_y];    % appending sigmas
    end
    
end
