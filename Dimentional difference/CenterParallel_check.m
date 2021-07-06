function [angle,p,first_center_point] = CenterParallel_check(points)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
[center_points,first_center_point] = FindCenterLine(points);
%% 7) center point is the mean of the two edge points in every section. 8) fit a least suares line(1st degree polynomial) for all center points
p = polyfit(center_points(:,1),center_points(:,2),1);
pp = polyval(p,center_points(:,1));

%plot(center_points(:,1),center_points(:,2));
angle = p(1);
end

