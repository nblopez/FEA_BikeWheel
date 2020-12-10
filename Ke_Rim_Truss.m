function ke = Ke_Rim_Truss(E, Ae, Xe, Ye)

%So this is super bare bones, basically breaks each rim element into two
%truss elements, tried for a few hours to improve this solution given the
%frame work we have but I couldn't really find anything that didn't require
%us to change our node mapping so for now this is what we got


% Define displacements across nodes on rim
X_diff1 = Xe(2)-Xe(1);
Y_diff1 = Ye(2)-Ye(1);

X_diff2 = Xe(3)-Xe(2);
Y_diff2 = Ye(3)-Ye(2);

%Define angles based on those deisplacements
theta1 = atan(Y_diff1/X_diff1);
c1 = cos(theta1);
s1 = sin(theta1);

theta2 = atan(Y_diff2/X_diff2);
c2 = cos(theta2);
s2 = sin(theta2);

%Initialize element matrices
k_e1 = zeros(6,6);
k_e2 = zeros(6,6);

%Compute truss matrix for half the element
k_e1(1:4,1:4) = [c1^2 c1*s1 -c1^2 -c1*s1;
           c1*s1 s1^2 -c1*s1 -s1^2;
           -c1^2 -c1*s1 c1^2 c1*s1;
           -c1*s1 -s1^2 c1*s1 s1^2];
       

k_e2(3:6,3:6) = [c2^2 c2*s2 -c2^2 -c2*s2;
           c2*s2 s2^2 -c2*s2 -s2^2;
           -c2^2 -c2*s2 c2^2 c2*s2;
           -c2*s2 -s2^2 c2*s2 s2^2];
       
%Combine element matrices
ke_basic = k_e1+k_e2;

ke = E*Ae*ke_basic;
end
