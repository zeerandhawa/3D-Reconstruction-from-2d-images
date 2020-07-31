function dispM = get_disparity(im1, im2, maxDisp, windowSize)
% GET_DISPARITY creates a disparity map from a pair of rectified images im1 and
% %   im2, given the maximum disparity MAXDISP and the window size WINDOWSIZE.
% load('../data/rectify.mat', 'M1', 'M2');
% im1 = imread('../data/im1.png');

% im1 = imread('../data/im1.png');
% im2 = imread('../data/im2.png');
% im1 = rgb2gray(im1);
% im2 = rgb2gray(im2);
% load('../data/rectify.mat', 'M1', 'M2', 'K1n', 'K2n', 'R1n', 'R2n', 't1n', 't2n');

%maxDisp = 20; 
%windowSize =11;
 [y, x] = size(im1);
dispMap = zeros(y , x);
best_x = 0;
best_y = 0;
I1 = im1;
I2 = im2;
w = (windowSize-1) / 2;
test = [3 3; 3 3];
new_test = padarray(test, [2 2], 0);
im1 = padarray(im1, [w w], 0, "both");
im2 = padarray(im2, [w w], 0);
best_error = 0;
for i = w+1:y-w+1
    for j = w+1:x-w+1
        first_patch = im1(i-w:i+w, j-w:j+w);
        mean = mean2(first_patch);
        std = std2(first_patch);
        first_patch = (first_patch - mean)/std;
          for ind = 0:maxDisp
              if(j+w+ind) > (x+2*w)
                  continue;
              end
              disp(j+w+ind);
              second_patch = im2(i-w:i+w, j-w+ind:j+w+ind);
              mean = mean2(second_patch);
              std = std2(second_patch);
              second_patch = (second_patch - mean)/std;
              error = sum((first_patch - second_patch) .^ 2, 'all');
              %error = sum(abs(first_patch - second_patch) , 'all');
              if ind == 0
                  best_error = error;
                  dispMap(i -w, j-w) = ind;
              end
              if error < best_error
                  best_error = error;
                  dispMap(i -w, j-w) = ind;
              end
          end
    end
end
dispM = dispMap;
%figure; imagesc(dispM.*(I1>40)); colormap(gray); axis image;
end
% for i = 51:52
%     for j = 151:152
%         figure();
%         imshow(im1);
%         axis on
%         hold on;
%         % Plot cross at row 100, column 50
%         plot(i,j, 'r+', 'MarkerSize', 10, 'LineWidth', 2);
%     end
% end