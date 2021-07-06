function [points] = moveToOrigin(points)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
X_start = min(points(:,1));
points(:,1) = points(:,1) - X_start;

Y_start = mean(points(:,2));
points(:,2) = points(:,2) - Y_start;

try
    Z_start = min(points(:,3));
    points(:,3) = points(:,3) - Z_start;
catch

end

end

