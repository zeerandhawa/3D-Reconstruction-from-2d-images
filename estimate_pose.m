function P = estimate_pose(x, X)
% ESTIMATE_POSE computes the pose matrix (camera matrix) P given 2D and 3D
% points.
%   Args:
%       x: 2D points with shape [2, N]
%       X: 3D points with shape [3, N]

% K = [1,0,1e2;0,1,1e2;0,0,1];
% 
% [R, ~, ~] = svd(randn(3));
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


[N, d] = size(X);
newcol = ones(1,d);
%X_hom = [X, newcol];
X_hom = vertcat(X, newcol);
X1 = X_hom(:,1);

A = zeros(2*d, 12);
for i = 0:d-1
%for i = 0:1
  ind = i+1;
  X1 = X_hom(:,ind);
  x1 = x(:,ind);
  x_prime = x1(1);
  y_prime = x1(2);
  disp([transpose(X1) 0 0 0 0 -x_prime * transpose(X1)]);
  A(2*i+1,:) = [transpose(X1) 0 0 0 0 -x_prime * transpose(X1)];
  A(2*i+2,:) = [0 0 0 0 transpose(X1) -y_prime * transpose(X1)];
end

[U, s, V] = svd(A);

  p_test = reshape(V(:, end), [4, 3]);
  p_test = transpose(p_test);
      P = p_test;
  %disp(p_test);
 
%P = estimateCameraMatrix(transpose(x), transpose(X));

end



