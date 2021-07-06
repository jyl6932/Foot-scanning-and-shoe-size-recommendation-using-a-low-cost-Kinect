function [P3] = ChoosePoint(P1,P2,point_groups,ptCloud)
%UNTITLED6 此处显示有关此函数的摘要
%   此处显示详细说明

[r,c] = size(point_groups);max_dis=[];distance_all=[];
for i = 1:r
    try
    P3_temp = point_groups(i,:);
    [normal, d] = plot_line(P1, P2, P3_temp);
    % 点到平面的距离，两侧小于0.5共1mm区间
    
    label = abs((sum(ptCloud.Location.*normal,2)+d)/sqrt(sum(normal.^2,2)))<0.5;
    points_curve = ptCloud.Location(label,:);
    
    %figure;hold on;
    %pcshow(ptCloud);
    %plot3(points_curve(:,1),points_curve(:,2),points_curve(:,3),'o','MarkerSize',10);

    n = d*normal/sum(normal.^2,2); unit = normal/sqrt(sum(normal.^2,2));
    points_curve_trans = points_curve+n;
   
    R = [unit(2)/sqrt(unit(1)^2+unit(2)^2), -unit(1)/sqrt(unit(1)^2+unit(2)^2), 0; unit(1)*unit(3)/sqrt(unit(1)^2+unit(2)^2), unit(2)*unit(3)/sqrt(unit(1)^2+unit(2)^2), -sqrt(unit(1)^2+unit(2)^2); unit(1), unit(2), unit(3)];
    points_curve_rotate = (R*points_curve_trans.')';

    convex=[points_curve_rotate(:,1),points_curve_rotate(:,2)];
    [k,av] = convhull(double(convex));
    %figure;hold on;
    %plot3(points_curve(:,1),points_curve(:,2),points_curve(:,3),'o','MarkerSize',10);
    %plot(convex(k,1),convex(k,2))
    convex_matrix = [points_curve_rotate(k,1),points_curve_rotate(k,2)];
    convex_matrix_tem =cat(1,convex_matrix(2:end,:),convex_matrix(1,:));
    distance = sum(sqrt(sum((convex_matrix_tem-convex_matrix).^2,2)));
    distance_all = cat(1,distance_all,distance);
    catch
        disp(i);
    end
        
end
[min_dis,min_idx] = min(distance_all);
P3 = point_groups(min_idx,:);
end

