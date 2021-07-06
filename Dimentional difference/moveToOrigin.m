function [points] = moveToOrigin(points)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
points = points(:,1:3);
bottomPoints = points(find(points(:,3)<35),:);
X_start = min(bottomPoints(:,1));
points(:,1) = points(:,1) - X_start;

Y_start = (max(bottomPoints(:,2))-min(bottomPoints(:,2)))/2;
points(:,2) = points(:,2)-max(bottomPoints(:,2))+Y_start;

pointsRound = points;
pointsRound(:,4) = round(points(:,1));
[angle,p] = CenterParallel_check(pointsRound);   
heel_point = [0,polyval(p,0),0];
points = points-heel_point;

end

