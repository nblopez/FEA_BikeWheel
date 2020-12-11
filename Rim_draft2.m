% Xe = [1 2 3];
% Ye = [-2 -5 -2];
thickness = 0.1
x_spoke = 3;
r = .125;
d_theta = 2 * pi / (x_spoke);
spoke_num = 1;

theta_arr = [-d_theta/2, 0, d_theta/2] + 0.1;

E = 1e6;
% theta1 = pi - tan(Ye(1)/Xe(1));
% theta3 = pi - tan(Ye(3)/Xe(3));
% d_theta = abs(theta3-theta1);
Le = r*d_theta;

syms S
assume(S, 'Real')
% assume([z, n], 'Real')
N1 = 2*S^2/Le^2 - 3*S/Le + 1;
N2 = -4*S^2/Le^2 + 4*S/Le;
N3 = 2*S^2/Le^2 - S/Le;
% Sx = sqrt(z^2+n^2)*atan(n/z);
% N_umat = [N1 N2 N3];
% N_mat = subs(N_umat,S,Sx);

N_mat = [N1, N2, N3];
N_diff = diff(N_mat, S);

rt_func = r * dot(theta_arr, N_mat);
% xe_func = dot(Xe, N_mat);
% ye_func = dot(Ye, N_mat);

J = diff(rt_func, S);
J_det = det(J); 

dN = J \ N_diff;
dNdx = dN * 1 ./ cos(theta_arr);
dNdy = dN * 1 ./ sin(theta_arr);


%Solve for derivitive wrt 
B = [dNdx(1), 0, dNdx(2), 0, dNdx(3), 0;...
    0, dNdy(1), 0, dNdy(2), 0, dNdy(3);...
    dNdy(1), dNdx(1), dNdy(2), dNdx(2), dNdy(3), dNdx(3)];

calc_mat = thickness *  B' * E * B * J_det;

ke = zeros(size(calc_mat));
w = [5/9, 8/9, 5/9] * Le;
for ii = 1:3
    ke = ke + subs(calc_mat, S, w(ii));
end

% 
% N = 2;
% [xg, wx] = lgwt(N,Xe(1),Xe(3));
% [yg, wy] = lgwt(N,Ye(1),Ye(3));
% wx = [8/9 
% 
% %Initialize stiffness matrix
% ke = 0;
% 
% %Iterate over all weight and points in x and y
% for i = 1:N
%     for j = 1:N
%         ke = ke + .5*wy(i)*wx(j)*subs(integrand,[x y],[xg(i) yg(j)]);
%     end
% end
% 
% 
% 
% ke = vpa(ke,6)







