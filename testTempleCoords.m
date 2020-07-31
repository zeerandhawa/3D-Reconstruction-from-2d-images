% A test script using templeCoords.mat
%
% Write your code here
%
I1 = imread("../data/im1.png");
I2 = imread("../data/im2.png");

load("../data/someCorresp.mat");
F = eightpoint(pts1, pts2, M);

load("../data/intrinsics.mat");
E = essentialMatrix(F, K1, K2);

load("../data/templeCoords.mat");
pts2 = epipolarCorrespondence(I1, I2, F, pts1);


%Extrinsic camera matrices
P11 = [1 0 0 0;
    0 1 0 0;
    0 0 1 0];
P1 = K1 * P11;  

M2s = camera2(E);
P2_1 = M2s(:,:,1);
P2_2 = M2s(:,:,2);
P2_3 = M2s(:,:,3);
P2_4 = M2s(:,:,4);
%Chosen one
P2 = K2*P2_3;
pts = triangulate(P1, pts1, P2, pts2 );


if pts(:,3) < 0
    P2 = K2*P2_4;
    pts = triangulate(P1, pts1, P2, pts2 );
end

figure();
scatter3(pts(:,1), pts(:,2), pts(:,3), "filled");
axis equal;
rotate3d('on')
  
 R1 = P11(:,1:3);
 t1 = P11(:,4);

R2 = P2_3(:, 1:3);
t2 = P2_3(:,4);
 
 
 E1 = transpose(t1)* R1;
 E2 = transpose(t2) * R2;
% save extrinsic parameters for dense reconstruction
save('../data/extrinsics.mat', 'R1', 't1', 'R2', 't2');