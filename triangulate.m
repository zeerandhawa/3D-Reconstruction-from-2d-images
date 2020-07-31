function pts3d = triangulate(P1, pts1, P2, pts2 )
% triangulate estimate the 3D positions of points from 2d correspondence
%   Args:
%       P1:     projection matrix with shape 3 x 4 for image 1
%       pts1:   coordinates of points with shape N x 2 on image 1
%       P2:     projection matrix with shape 3 x 4 for image 2
%       pts2:   coordinates of points with shape N x 2 on image 2
%
%   Returns:
%       Pts3d:  coordinates of 3D points with shape N x 3
%
% I1 = imread("../data/im1.png");
% I2 = imread("../data/im2.png");
% 
% load("../data/someCorresp.mat");
% F = eightpoint(pts1, pts2, M);
% load("../data/intrinsics.mat");
% E = essentialMatrix(F, K1, K2);



% load("../data/templeCoords.mat");
% pts2 = epipolarCorrespondence(I1, I2, F, pts1);
% P1 = [1 0 0 0;
%     0 1 0 0;
%     0 0 1 0];
% P1 = K1 * P1;    
% 
% M2s = camera2(E);
% P2_1 = M2s(:,:,1);
% P2_2 = M2s(:,:,2);
% P2_3 = M2s(:,:,3);
% P2_4 = M2s(:,:,4);
disp(size(pts1));
[N, d] = size(pts1);
newcol = ones(N,1);
pts1 = [pts1, newcol];
pts2 = [pts2, newcol];

%POINTSS = zeros(N,3);
Test_reprojected = zeros(N,3);
POINTSS = zeros(N,4);
for i = 1:N
%for i = 1:1
    point1 = pts1(i,:);
    point2 = pts2(i,:);
    x = point1(1);
    y = point1(2);
    x_prime = point2(1);
    y_prime = point2(2);
    p11 = P1(1,:);
    p22 = P1(2,:);
    p33 = P1(3,:);
    
    
    %P2_1 = K2*P2_4;
    P2_1 = P2;
    
    
    p1 = P2_1(1,:);
    p2 = P2_1(2,:);
    p3 = P2_1(3,:);
    A1 = [p22 - p33*y;
        p11 - p33*x];
    
    [U, s, V] = svd(A1);
%     A2 = [p2 - p3*y_prime;
%        p1 - p3*x_prime];
     %Referred to CMU lecture slides
     A2 = [p2 - p3*y_prime;
       p1 - p3*x_prime;
       p22 - p33*y;
        p11 - p33*x];
    [U1, s1, V1] = svd(A2);
    point_got_from_2 = V1(:,end);
    point_got_from = point_got_from_2/point_got_from_2(end);
    
    %Reprojecting to check REPROJECTION ERROR
    test = P2_1*point_got_from;
    test1 = round(test/test(3));
    Test_reprojected(i,:) = transpose(test1);
    
    POINTSS(i,:) = transpose(point_got_from);
    
    %(point_got_from(1), point_got_from(2), point_got_from(3));
end
% disp(size(Test_reprojected));
% disp(size(pts2));
% disp(pts2(1:10,:));
% 
% disp(Test_reprojected(1:10,:));
%error = sum((abs(Test_reprojected(:,1) - pts2(:,1)) + abs(Test_reprojected(:,2) - pts2(:,2))),"all")/(2 * N);
error = abs(sum(((Test_reprojected(:,1) - pts2(:,1)) + (Test_reprojected(:,2) - pts2(:,2))),"all")/(2 * N));
%error = abs(sum(sqrt((Test_reprojected(:,1) - pts2(:,1)).^2 + (Test_reprojected(:,2) - pts2(:,2)).^2),"all")/( N));
disp(error);
%  figure();
%  scatter3(POINTSS(:,1), POINTSS(:,2), POINTSS(:,3), "filled");
%  rotate3d('on')
%   axis equal
  pts3d = POINTSS;
end
