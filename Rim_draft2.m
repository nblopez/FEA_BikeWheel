Xe = [1 2 3];
Ye = [-2 -5 -2];

E = 1e6;
theta1 = pi - tan(Ye(1)/Xe(1));
theta3 = pi - tan(Ye(3)/Xe(3));
d_theta = abs(theta3-theta1);
Le = .125*d_theta;

syms S z n real
N1 = 2*S^2/Le^2 - 3*S/Le;
N2 = -4*S^2/Le^2 + 4*S/Le;
N3 = 2*S^2/Le^2 - S/Le;
Sx = sqrt(z^2+n^2)*atan(n/z);
N_umat = [N1 N2 N3];
N_mat = subs(N_umat,S,Sx);

Nu_d = sym('a' ,2);
for k = 1:3
    Nu_d(1,k) = diff(N_mat(k),z);
    Nu_d(2,k) = diff(N_mat(k),n);
end


%Find derivative of global coordinates wrt local coordinates
dx_dz = 0; dy_dz = 0; dx_dn = 0; dy_dn = 0;
for i = 1:3
    dx_dz = dx_dz + Xe(i)*diff(N_mat(i),z);
    dy_dz = dy_dz + Ye(i)*diff(N_mat(i),z);
    dx_dn = dx_dn + Xe(i)*diff(N_mat(i),n);
    dy_dn = dy_dn + Ye(i)*diff(N_mat(i),n);
end

%Compile Jacobian Matrix
J(1,1) = dx_dz; J(1,2) = dy_dz; J(2,1) = dx_dn; J(2,2) = dy_dn;
J = vpa(J,5);

%Solve for derivitive wrt 
N_d = inv(J)*Nu_d;

B = [N_d(1,1) 0 N_d(1,2) 0 N_d(1,3) 0
    0 N_d(2,1) 0 N_d(2,2) 0 N_d(2,3)
    N_d(1,1) N_d(2,1) N_d(1,2) N_d(2,2) N_d(1,3) N_d(2,3)];

integrand = B'*E*B;
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







