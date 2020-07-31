function [pts22] = epipolarCorrespondence(I1, I2, F, pts1)
% epipolarCorrespondence:
%   Args:
%       im1:    Image 1
%       im2:    Image 2
%       F:      Fundamental Matrix from im1 to im2
%       pts1:   coordinates of points in image 1
%   Returns:
%       pts2:   coordinates of points in image 2
%

% I1 = imread("../data/im1.png");
% I2 = imread("../data/im2.png");
% 
% load("../data/someCorresp.mat");
% F = eightpoint(pts1, pts2, M);
% Im1 = I1;
% Im2 = I2;
% pts11 = pts1;
% %load("../data/templeCoords.mat");
[N, d] = size(pts1);
newcol = ones(N,1);
pts1_hom = [pts1, newcol];
%pts1_hom = [pts11, newcol];
n = length(pts1);
pts22 = zeros(n,2);
best_x_prime = 0;
best_y_prime = 0;

for b = 1:N

    %x1 = pts1_hom(1,:);
    x1 = pts1_hom(b,:);
    x = x1(1);
    y = x1(2);
    %l1 = x1 * F;
    l1_prime = F * transpose(x1);
    %l1_prime = epipolarLine(F,x1(1:2)); 
    points = lineToBorderPoints(transpose(l1_prime),size(I1));
       
    estimated = pts1_hom(b,:);
    sz=8;    
    I1 = double(I1);
    I2 = double(I2);
    wind1 = I1((y-sz):(y+sz), (x-sz):(x+sz));
    best_error=1000;
    l1_prime = transpose(l1_prime);
    samples = 300;
    x_cands = round(linspace(points(:,1), points(:,3), samples));
    %candidate x coordinates
    x_possible = estimated(1);
    for i=x_possible-25:x_possible+25
        a = l1_prime(1, 1);
        bt = l1_prime(1, 2);
        c = l1_prime(1, 3);
        x = i;
        y_prime_possible = round((a*x + c)/(-bt));
        %candidate y coordinates
    	for j=y_prime_possible-15:y_prime_possible+15
            wind2 = I2(j-sz:j+sz,i-sz:i+sz);
            error = sqrt(sum((wind1 - wind2) .^ 2, 'all'));
            if error<best_error
                best_error=error;
                best_x_prime=i;
                best_y_prime=j;
            end   
    	end
    end
    
    pts2 = [best_x_prime, best_y_prime];
    pts22(b,:) = pts2;
%     disp(b);
    best_x_prime = 0;
    best_y_prime = 0;
end
% 
% figure();
% imshow(Im1)
% hold on
% plot(x,y, '*','Color',"red");
% hold off;
% figure();
% imshow(Im2)
% hold on
% line(points(:,[1,3]),points(:,[2,4]));
% plot(best_x_prime,best_y_prime, '*','Color',"red");
% hold off;
% [s, d] = epipolarMatchGUI(I1, I2, F);
%l1_prime = F * transpose(x1);

end



