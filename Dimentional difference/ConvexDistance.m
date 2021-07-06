function [distance] = ConvexDistance(P1,P2,P3,points)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
[normal, d] = plot_line(P1,P2,P3);
label = abs((sum(points.*normal,2)+d)/sqrt(sum(normal.^2,2)))<0.8;
points_curve = points(label,:);


n = d*normal/sum(normal.^2,2); unit = normal/sqrt(sum(normal.^2,2));
points_curve_trans = points_curve+n;
   
R = [unit(2)/sqrt(unit(1)^2+unit(2)^2), -unit(1)/sqrt(unit(1)^2+unit(2)^2), 0; unit(1)*unit(3)/sqrt(unit(1)^2+unit(2)^2), unit(2)*unit(3)/sqrt(unit(1)^2+unit(2)^2), -sqrt(unit(1)^2+unit(2)^2); unit(1), unit(2), unit(3)];
points_curve_rotate = (R*points_curve_trans.')';

convex=[points_curve_rotate(:,1),points_curve_rotate(:,2)];
[k,av] = convhull(double(convex));
 
convex_matrix = [points_curve_rotate(k,1),points_curve_rotate(k,2)];
convex_matrix_tem =cat(1,convex_matrix(2:end,:),convex_matrix(1,:));
distance = sum(sqrt(sum((convex_matrix_tem-convex_matrix).^2,2)));

end

