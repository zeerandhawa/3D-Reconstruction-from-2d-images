load("../data/PnP.mat");
% figure();
% imshow(image);

P = estimate_pose(x, X);
[K, R , t] = estimate_params(P);

[N, d] = size(x);
newcol = ones(1,d);
x_new =  vertcat(x, newcol);
X_new =  vertcat(X, newcol);

x_projected = P * X_new;
test = x_projected(3,:);
x_proj = x_projected(1:2,:) ./ x_projected(3,:);
x_proj = transpose(x_proj);

figure();
imshow(image);
hold on;
x = transpose(x);
scatter(x(:,1), x(:,2), 55, 'black');
scatter(x_proj(:,1), x_proj(:,2), 14, 'green', 'o', 'filled');
hold off;


ver = cad.vertices;
ver = ver *R;
%ver = R * transpose(cad.vertices);
%ver = transpose(ver);
figure();
trimesh(cad.faces,  ver(:, 1), ver(:, 2),ver(:, 3), 'edgecolor', 'blue');



ver = cad.vertices;
[N, d] = size(ver);
newcol = ones(N, 1);
ver_new =  horzcat(ver, newcol);
projected = P * transpose(ver_new);
unhom_projected = projected(1:2,:)./projected(3,:);

figure();
imshow(image);
hold on;
vertices = transpose(unhom_projected);
patch('Faces',cad.faces,'Vertices',vertices,'FaceColor','red', 'FaceAlpha' , 0.20, 'EdgeColor', 'none');
%trimesh(cad.faces,  vertices(:, 1), vertices(:, 2));
%hold off;