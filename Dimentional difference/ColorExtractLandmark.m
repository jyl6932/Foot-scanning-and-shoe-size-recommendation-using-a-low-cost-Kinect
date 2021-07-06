function [points,I] = ColorExtractLandmark(PointCloud)
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
I = PointCloud.Color(:,3) - max(PointCloud.Color(:,	1:2),[],2);
points = PointCloud.Location(find(I>25),:);
[ptCloudOut,inlierIndices,outlierIndices] = pcdenoise(pointCloud(points),'NumNeighbors',4,'Threshold',0.7);
[labels,numClusters] = pcsegdist(ptCloudOut,10);

if(numClusters>10|numClusters<5)
    points = PointCloud.Location(find(I>35),:);
    [ptCloudOut,inlierIndices,outlierIndices] = pcdenoise(pointCloud(points),'NumNeighbors',10,'Threshold',0.7);
    [labels,numClusters] = pcsegdist(ptCloudOut,10);
end



end

