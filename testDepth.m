clear all ;
% Load image and paramters
im1 = imread('../data/im1.png');
im2 = imread('../data/im2.png');
im1 = rgb2gray(im1);
im2 = rgb2gray(im2);
load('../data/rectify.mat', 'M1', 'M2', 'K1n', 'K2n', 'R1n', 'R2n', 't1n', 't2n');

[rectIL, rectIR, bbL, bbR] = warp_stereo(im1, im2, M1, M2);
% figure();
% imshow(rectIL);
% figure();
% imshow(rectIR);
[x, y] = size(im1);
rectImg1 = zeros(size(im1)) ;
rectImg1(1:x,1:y) = rectIL(1:x,end - y+1-10:end-10);
%figure();
rectImg1 = uint8(rectImg1);
%imshow(rectImg1);
% figure();
% imshow(rectIR);
rectImg2 = zeros(size(im2)) ;
rectImg2(1:x,1:y) = rectIR(1:x,11:y+10);
%figure();
rectImg2 = uint8(rectImg2);
%imshow(rectImg2);


im1 = rectImg1;
im2 = rectImg2;
maxDisp = 20; 
windowSize = 9;
%dispM = get_disparity(im1, im2, maxDisp, windowSize);
dispM = get_disparity(rectImg1, rectImg2, maxDisp, windowSize);
save('../data/depth.mat', 'dispM');
%--------------------  get depth map
%load('../data/depth.mat', 'dispM');
depthM = get_depth(dispM, K1n, K2n, R1n, R2n, t1n, t2n);


% --------------------  Display

figure; imagesc(dispM.*(im1>40)); colormap(gray); axis image;
figure; imagesc(depthM.*(im1>40)); colormap(gray); axis image;
