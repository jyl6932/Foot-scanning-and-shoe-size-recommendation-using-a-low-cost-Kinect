function [pointsSorted] = orderOutline(points)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
%分割成三段分别排序
footLength = max(points(:,1));
UpFoot = points(find((points(:,2)>=0)&(points(:,1)<=footLength*0.95)),:);
DownFoot = points(find((points(:,2)<0)&(points(:,1)<=footLength*0.95)),:);
ToeFoot = points(find(points(:,1)>footLength*0.95),:);

[~,idxUp] = sort(UpFoot(:,1));
sortedUpFoot = UpFoot(idxUp,:);
[~,idxDown] = sort(DownFoot(:,1),'descend');
sortedDownFoot = DownFoot(idxDown,:);
[~,idxToe] = sort(ToeFoot(:,2),'descend');
sortedToeFoot = ToeFoot(idxToe,:);
pointsSorted = cat(1,sortedUpFoot,sortedToeFoot,sortedDownFoot);
end

