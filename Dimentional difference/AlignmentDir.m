function [ptCloud] = AlignmentDir(ptCloud)
%ALIGNMENTDIR 此处显示有关此函数的摘要
%   此处显示详细说明
%% Check if the model is in the right direction -- Y
points = ptCloud.Location;
upper_z_points =  ptCloud.Location(find(ptCloud.Location(:,3)>0));
lower_z_points =  ptCloud.Location(find(ptCloud.Location(:,3)<0));

upper_size = size(upper_z_points);
lower_size = size(lower_z_points);

if ( upper_size(1) < lower_size(1))
    points = cat(2,points(:,1:2),-points(:,3));
    [points] = NormalPC(points);
    disp('wrong z direction')
end

%% Check if the model is in the right direction --X
ptCloud = pointCloud(points);
bottom =  ptCloud.Location(find(ptCloud.Location(:,3)<25),:);
forward = bottom(find((bottom(:,1)>ptCloud.XLimits(2)*0.7)&(bottom(:,1)<ptCloud.XLimits(2)*0.75)),:);
heel = bottom(find((bottom(:,1)>ptCloud.XLimits(2)*0.3)&(bottom(:,1)<ptCloud.XLimits(2)*0.35)),:);
if ((max(forward(:,2))-min(forward(:,2)))<(max(heel(:,2))-min(heel(:,2))))
    points(:,1) = -points(:,1);
    [points] = NormalPC(points);
    disp('wrong x direction')
end

%% Check if the model is in the right direction -- XY
XLength =  ptCloud.XLimits(2) - ptCloud.XLimits(1);
YLength =  ptCloud.YLimits(2) - ptCloud.YLimits(1);

if ( YLength> XLength)
    R = [0 1 0; 1 0 0; 0 0 1];
    points = (R*points')';
    [points] = NormalPC(points);
    disp('wrong xy direction')
end

%% Check if the model is in the right direction --X
ptCloud = pointCloud(points);
bottom =  ptCloud.Location(find(ptCloud.Location(:,3)<25),:);
forward = bottom(find((bottom(:,1)>ptCloud.XLimits(2)*0.7)&(bottom(:,1)<ptCloud.XLimits(2)*0.75)),:);
heel = bottom(find((bottom(:,1)>ptCloud.XLimits(2)*0.3)&(bottom(:,1)<ptCloud.XLimits(2)*0.35)),:);
if ((max(forward(:,2))-min(forward(:,2)))<(max(heel(:,2))-min(heel(:,2))))
    points(:,1) = -points(:,1);
    [points] = NormalPC(points);
    disp('wrong x direction')
end
ptCloud = pointCloud(points);
% Make Left and Right foot same side
upper_z_points =  ptCloud.Location(find(ptCloud.YLimits(1)+(ptCloud.YLimits(2)-ptCloud.YLimits(1))*0.8<ptCloud.Location(:,2)),:);
lower_z_points =  ptCloud.Location(find(ptCloud.YLimits(1)+(ptCloud.YLimits(2)-ptCloud.YLimits(1))*0.2>ptCloud.Location(:,2)),:);
if(max(upper_z_points(:,1))<max(lower_z_points(:,1)))
    points(:,2) = -ptCloud.Location(:,2);
    disp('wrong foot side direction')
end

[ptCloud] = pointCloud(moveToOrigin(points));
end

