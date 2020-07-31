function F = eightpoint(pts1, pts2, M)
% eightpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)
% I1 = imread("../data/im1.png");
% I2 = imread("../data/im2.png");
% load("../data/someCorresp.mat");
% p1 = pts1;
% p2 = pts2;

[N, d] = size(pts1);
newcol = ones(N,1);
pts1_hom = [pts1, newcol];
pts2_hom = [pts2, newcol];
% Q2.1 - Todo:
%     Implement the eightpoint algorithm
%     Generate a matrix F from correspondence '../data/some_corresp.mat'
T =[2/M 0 0;
    0 2/M 0;
    0   0   1];
pts1_hom = pts1_hom * T;
pts2_hom = pts2_hom * T;
A = zeros(N, 9);
for i = 1:N
    if i == N
        disp('true');
    end
    x1 = pts1_hom(i, 1);
    x1_prime = pts2_hom(i, 1);
    y1 = pts1_hom(i, 2);
    y1_prime = pts2_hom(i, 2);

    A(i,:) = [x1_prime * x1 x1_prime * y1 x1_prime y1_prime * x1 y1_prime * y1 y1_prime x1 y1 1]; 
end
[U, S, V] = svd(A);
%V = transpose(V);
F = V(:,9);
F = reshape(F, [3, 3]);
F = T' * F * T;
%ENFORCING RANK 2
% [U, SS, V] = svd(F);
%  SS(3, 3) = 0;
% %SS(:, end) = 0;
% F= U * SS * V;

F_min = refineF(F, pts1, pts2);

 %displayEpipolarF(I1, I2, F_min);    
F = F_min;
end