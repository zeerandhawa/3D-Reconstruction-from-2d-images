function [K, R, t] = estimate_params(P)
% ESTIMATE_PARAMS computes the intrinsic K, rotation R and translation t from
% given camera matrix P.
% 
% K = [1,0,1e2;0,1,1e2;0,0,1];
% 
% [R, ~, ~] = svd(randn(3));
% if det(R) < 0
%     R = -R;
% end
% t = randn(3, 1);
% 
% P = K*[R, t];
% 
% % Random generate 2D and 3D points
% N = 10;
% X = randn(3, N);
% x = P*[X; ones(1, N)];
% x(1, :) = x(1, :)./x(3, :);
% x(2, :) = x(2, :)./x(3, :);
% x = x(1:2, :);
% 
% % test
% PClean = estimate_pose(x, X);

% 
% PClean = P;
[U, S, V] = svd(P);
C = V(:, end);
C1 = C/C(end);
C1 = C1(1:3);
% 
% C1 = V(1:3,end) / V(end, end);


%Clean implementation of RQ decomposition from scratch based on the
%stackexchange link provided in the handout

P_mul = [0 0 1;
    0 1 0;
    1 0 0];
M = P(:,1:3);
%Reversed rows of M
M_rev = P_mul * M;
%Transposing to use inbuild qr decomposition in Matlab
M_rev = transpose(M_rev);
[somQ, somR] = qr(M_rev);
%somR corresponding to K which should be the upper traiangle matrix 

K = P_mul * transpose(somR) * P_mul;
R = P_mul * transpose(somQ) ;

t = -R*C1;
%t = -R * -inv(P(:, 1: 3)) * P(:, 4);

% some = inv (K) * P ;
% some = -some(:,end);
% t = some;

end
