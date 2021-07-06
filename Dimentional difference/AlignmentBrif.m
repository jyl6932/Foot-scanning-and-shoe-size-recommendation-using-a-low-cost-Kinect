function [ptCloud] = AlignmentBrif(ptCloud)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
% Only consider the bottom part of the foot (25mm)
points = moveToOrigin(ptCloud.Location);
points_bottom = points(find(points(:,3)<30),:);

% Align the foot to make the foreword part in balance
x = round(max(points_bottom(:,1))*0.73);
y1 = points_bottom(find(round(points_bottom(:,1))==x-2),2);y2 = points_bottom(find(round(points_bottom(:,1))==x),2);y3 = points_bottom(find(round(points_bottom(:,1))==x+2),2);y4 = points_bottom(find(round(points_bottom(:,1))==x+1),2);y5 = points_bottom(find(round(points_bottom(:,1))==x-1),2);
y = cat(1,y1,y2,y3,y4,y5); y_min = min(y);y_max = max(y); y = cat(1,y_min,y_max);

dis = (y_max - y_min)/2 + y_min;
angle = atand(dis/x);
threshold = 0.001;timer = 0;
while abs(angle)>threshold
    [points] = CenterParallel_perform(points,[0,0,0],angle);
    points_bottom = points(find(points(:,3)<25),:);
    x = round(max(points_bottom(:,1))*0.73);
    y1 = points_bottom(find(round(points_bottom(:,1))==x-2),2);y2 = points_bottom(find(round(points_bottom(:,1))==x),2);y3 = points_bottom(find(round(points_bottom(:,1))==x+2),2);y4 = points_bottom(find(round(points_bottom(:,1))==x+1),2);y5 = points_bottom(find(round(points_bottom(:,1))==x-1),2);
    y = cat(1,y1,y2,y3,y4,y5); y_min = min(y);y_max = max(y); y = cat(1,y_min,y_max);
    dis = (y_max - y_min)/2 + y_min;
    angle = atand(dis/x);
    disp("angle "+angle+'!!!');
    timer = timer+1;
    if(timer==20)
        break;
    end
end

% Make Left and Right foot same side
point_below = points(find(points(:,2)<0),:);
point_above = points(find(points(:,2)>0),:);
if(max(point_above(:,1))>max(point_below(:,1)))
    points(:,2) = -points(:,2);
end

[ptCloud] = pointCloud(moveToOrigin(points));
end

