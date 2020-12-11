Xe = [-2 0 2];
Ye = [-2 -3 -2];

E = 1e6;
theta1 = pi - tan(Ye(1)/Xe(1));
theta3 = pi - tan(Ye(3)/Xe(3));
d_theta = abs(theta3-theta1);
Le = .125*d_theta;

syms S x y
assume([x, y], 'Real')
N1 = 2*S^2/Le^2 - 3*S/Le;
N2 = -4*S^2/Le^2 + 4*S/Le;
N3 = 2*S^2/Le^2 - S/Le;
Sx = sqrt(x^2+y^2)*atan(y/x);
N_umat = [N1 N2 N3];
N_mat = subs(N_umat,S,Sx);

B = sym('a' ,2);
for k = 1:3
    B(1,k) = diff(N_mat(k),x);
    B(2,k) = diff(N_mat(k),y);
end

integrand = B'*E*B;
N = 3;
[xg, wx] = lgwt(N,Xe(1),Xe(3));
[yg, wy] = lgwt(N,Ye(1),Ye(3));

%Initialize stiffness matrix
ke = 0;

%Iterate over all weight and points in x and y
for i = 1:N
    for j = 1:N
        ke = ke + .5*wx(i)*wy(j)*subs(integrand,[x y],[xg(i) yg(j)]);
    end
end

ke = vpa(ke,6)







