 function [M1, M2, K1n, K2n, R1n, R2n, t1n, t2n] = ...
                         rectify_pair(K1, K2, R1, R2, t1, t2)
% RECTIFY_PAIR takes left and right camera paramters (K, R, T) and returns left
%   and right rectification matrices (M1, M2) and updated camera parameters. You
%   can test your function using the provided script q4rectify.m

%Finding the camera centres

% load("../data/intrinsics.mat");
% load("../data/extrinsics.mat");
C1 = -inv(K1 * R1) * K1*t1;
C2 = -inv(K2 * R2) * K2*t2;

%Calculating the new axis of the image plane
%x_axis = C2 - C1/(C2 - C1);

x_axis = C2 - C1;
x_axis = x_axis/norm(C2 - C1);
%disp(C1 - C2);
test = C2 - C1;
if (test(1)) >= 0
    x_axis = C1 - C2;
    x_axis = x_axis/norm(C1 - C2);
end
%  x_axis = C1 - C2;
% x_axis = x_axis/norm(C1 - C2);
r1 = x_axis;

y_axis = cross(R1(:,3), r1);
r2 = y_axis;

z_axis = cross(r2, r1);
r3 = z_axis;

R_new = zeros(3,3);
R_new(1,:) = transpose(r1);
R_new(2,:) = transpose(r2);
R_new(3,:) = transpose(r3);

K_new = K2;
K2n = K_new;
K1n = K_new;
 t1n=-R_new*C1;
 t2n=-R_new*C2;
R1n = R_new;
R2n = R_new;
M1 = K_new * R_new * inv(K1 * R1);
M2 = K_new * R_new * inv(K2 * R2);

% E1 = t1 * R1;
% E2 = t2 * R2;
% [U, S, V] = svd(E1);


end