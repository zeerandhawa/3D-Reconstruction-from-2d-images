function depthM = get_depth(dispM, K1, K2, R1, R2, t1, t2)
% GET_DEPTH creates a depth map from a disparity map (DISPM).
disp("test");
C1 = -inv(K1 * R1) * K1*t1;
C2 = -inv(K2 * R2) * K2*t2;

x_axis = C1 - C2;
b = norm(x_axis);
disp(b);
f = K1(1,1);
[y, x] = size(dispM);
depthM = zeros(y, x);
for i = 1:y
    for j = 1:x
        if dispM(i,j) == 0
            depthM(i,j) = 0; 
        else
            depthM(i,j) = b*f/(dispM(i, j)); 
        end
    end
end
end