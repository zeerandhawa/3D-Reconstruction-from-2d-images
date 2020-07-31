function E = essentialMatrix(F, K1, K2)
% essentialMatrix computes the essential matrix 
%   Args:
%       F:  Fundamental Matrix
%       K1: Camera Matrix 1
%       K2: Camera Matrix 2
%
%   Returns:
%       E:  Essential Matrix
%
% I1 = imread("../data/im1.png");
% I2 = imread("../data/im2.png");
% 
% load("../data/someCorresp.mat");
% F = eightpoint(pts1, pts2, M);
% 
% load("../data/intrinsics.mat");

%E = transpose(inv(K1)) * F * K1;
E = K2' * F * K1;
%camera = cameraParameters(K1);
%[E_test, e] = estimateEssentialMatrix(pts1, pts2);
%displayEpipolarF(I1, I2, E);  
end