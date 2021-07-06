function [points] = moveAlign(points,heel_point);
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
points(:,1) = points(:,1) - min(points(:,1));

points(:,2) = points(:,2) - heel_point(2);


end

