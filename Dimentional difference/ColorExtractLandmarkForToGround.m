function [points,I] = ColorExtractLandmarkForToGround(PointCloud)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
I = PointCloud.Color(:,1) - max(PointCloud.Color(:,	2:3),[],2);
points = PointCloud.Location(find(I>10),:);

[labels,numClusters] = pcsegdist(pointCloud(points),20);

%for ExScan
sizePoints = size(points);
if(numClusters<4|sizePoints(1)>1000)
    points = PointCloud.Location(find(I>50),:);
    [labels,numClusters] = pcsegdist(pointCloud(points),5);
end


end

% exscan 25 75
% kinect 10 15