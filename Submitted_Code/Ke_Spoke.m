function ke = Ke_Spoke(E, Ae, Xe, Ye)
% Define displacement across spoke
X_diff = Xe(1)-Xe(2);
Y_diff = Ye(1)-Ye(2);

%Calculate angle of spoke
theta = atan(Y_diff/X_diff);
c = cos(theta);
s = sin(theta);

%Construct basic truss matrix
k_basic = [c^2 c*s -c^2 -c*s;
           c*s s^2 -c*s -s^2;
           -c^2 -c*s c^2 c*s;
           -c*s -s^2 c*s s^2];
%Multiply by E and Cross Sectional Area       
ke = Ae*E*k_basic;

end
