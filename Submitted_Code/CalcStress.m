function [sig_xx, sig_yy] = CalcStress(spoke, rim, X, Y, U, nodemap)

    map_hub = nodemap(1:spoke.count,1:2);  % separating hub elements
    
    map_spoke =  nodemap(spoke.count+1:2*spoke.count,1:2);  % separating spoke elements
    
    map_rim = nodemap(2*spoke.count+1:end,1:3) ; % separating rim elements
    
    num_nodes = max(max(nodemap));
    
    sig_xx = zeros(num_nodes,1);        
    sig_yy = zeros(num_nodes,1); 
    
    [spoke.sig_xx, spoke.sig_yy] = spoke_Stress(spoke, U, map_spoke);
    
    sig_xx(map_spoke(:,1)) = sig_xx(map_spoke(:,1)) + spoke.sig_xx;
    sig_yy(map_spoke(:,1)) = sig_yy(map_spoke(:,1)) + spoke.sig_yy;
    sig_xx(map_spoke(:,2)) = sig_xx(map_spoke(:,2)) + spoke.sig_xx;
    sig_yy(map_spoke(:,2)) = sig_yy(map_spoke(:,2)) + spoke.sig_yy;

    
    [rim.sig_xx, rim.sig_yy] = rim_Stress(rim, spoke, X, Y, U, map_rim);
    sig_xx(map_rim(:,1)) = sig_xx(map_rim(:,1)) + rim.sig_xx;
    sig_yy(map_rim(:,1)) = sig_yy(map_rim(:,1)) + rim.sig_yy;
    sig_xx(map_rim(:,2)) = sig_xx(map_rim(:,2)) + rim.sig_xx;
    sig_yy(map_rim(:,2)) = sig_yy(map_rim(:,2)) + rim.sig_yy;
    sig_xx(map_rim(:,3)) = sig_xx(map_rim(:,3)) + rim.sig_xx;
    sig_yy(map_rim(:,3)) = sig_yy(map_rim(:,3)) + rim.sig_yy;
    
end



function [sig_xx, sig_yy] = spoke_Stress(spoke, U, spoke_nodemap)
    
    l = spoke.length;
    sig_xx = spoke.E*(U(2*spoke_nodemap(:,1)-1)-U(2*spoke_nodemap(:,2)-1))/l;
    sig_yy = spoke.E*(U(2*spoke_nodemap(:,1))-U(2*spoke_nodemap(:,2)))/l;

end


function [sig_xx, sig_yy] = rim_Stress(rim, spoke, Xe, Ye, U, map_rim)
    

    start_angle = atan(Ye(2) / Xe(2));
    r = rim.diameter / 2;
    d_theta = 2 * pi / (spoke.count);
    
    theta_arr = [-d_theta/2, 0, d_theta/2] + 0.1 + start_angle;
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
        dofs = max(map_rim(i,:))*2 - 5:max(map_rim(i,:)*2);
        sig =  E_rim*B*U(dofs);                     % stress calculation
        sig_x = sig(1);
        sig_y = sig(2);
        sig_xx = [sig_xx; sig_x];    % appending sigmas
        sig_yy = [sig_yy; sig_y];
    end
    
    sig_xxd = 0;
    sig_yyd = 0;
    w = [5/9, 8/9, 5/9] * Le;
    for ii = 1:3
        sig_xxd = sig_xxd + subs(sig_xx, S, w(ii));
        sig_yyd = sig_yyd + subs(sig_yy, S, w(ii));
    end
   
    sig_xx = sig_xxd;
    sig_yy = sig_yyd;
    
end
