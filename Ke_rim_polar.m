function ke = Ke_rim_polar(rim, spoke, Xe, Ye, ang_offset)

start_angle = atan(Ye(2) / Xe(2));
% Xe = [1 2 3];
% Ye = [-2 -5 -2];
r = rim.diameter / 2;
d_theta = 2 * pi / (spoke.count);

theta_arr = [-d_theta/2, 0, d_theta/2] + ang_offset + start_angle;

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

calc_mat = rim.depth *  B' * rim.E * B * J_det;

ke = zeros(size(calc_mat));
w = [5/9, 8/9, 5/9] * Le;
for ii = 1:3
    ke = ke + subs(calc_mat, S, w(ii));
end
% vpa(ke, 4)







