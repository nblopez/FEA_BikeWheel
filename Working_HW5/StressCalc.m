function [s_xx, s_yy] = StressCalc(X, Y, U, E, N_func, N_diff, nodemap)
s_xx = zeros(4, 1);
s_yy = zeros(4, 1);

enodes = nodemap(5, :);
Xe = X(enodes);
Ye = Y(enodes);

Ux = U(1:2:end);
Uy = U(2:2:end);
Ue = zeros(8,1);
Ue(1:2:end) = Ux(enodes);
Ue(2:2:end) = Uy(enodes);
wx = [1/sqrt(3), -1/sqrt(3), -1/sqrt(3), 1/sqrt(3)];
wy = [1/sqrt(3), 1/sqrt(3), -1/sqrt(3), -1/sqrt(3)];

for ii = 1:4
    strain_out = strain_func(Xe, Ye, Ue, N_func, N_diff, wx(ii), wy(ii));
    stress = E * strain_out;
    s_xx(ii) = stress(1);
    s_yy(ii) = stress(2);    
end
end

function strain_out = strain_func(Xe, Ye, Ue, N_func, N_diff, w1, w2)
global eta
global zeta

xe_func = dot(Xe, N_func);
ye_func = dot(Ye, N_func);

J = [diff(xe_func, zeta), diff(ye_func, zeta);...
    diff(xe_func, eta), diff(ye_func, eta)];
dN = J \ N_diff;
dNdx = dN(1, :);
dNdy = dN(2, :);

B = [dNdx(1), 0, dNdx(2), 0, dNdx(3), 0, dNdx(4), 0;...
    0, dNdy(1), 0, dNdy(2), 0, dNdy(3), 0, dNdy(4);...
    dNdy(1), dNdx(1), dNdy(2), dNdx(2), dNdy(3), dNdx(3), dNdy(4), dNdx(4)];

strain_calc = B * Ue;

strain_out = subs(subs(strain_calc, zeta, w1), eta, w2);
end




