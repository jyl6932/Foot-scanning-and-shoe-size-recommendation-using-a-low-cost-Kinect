function [distance] = ConvexDistancePerPlane(P1,axis,points,FileName)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
label = find(abs(points(:,3)-P1(3))<0.8);
points_curve = points(label,:);

convex=[points_curve(:,1),points_curve(:,2)];
[k,av] = convhull(double(convex));

convex_matrix = [points_curve(k,1),points_curve(k,2)];
convex_matrix_tem =cat(1,convex_matrix(2:end,:),convex_matrix(1,:));
distance = sum(sqrt(sum((convex_matrix_tem-convex_matrix).^2,2)));
end

