function [points] = AlignmentBrif(points)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
points_size = size(points);
if(points_size(2) == 3) 
    [points] = moveToOrigin(points);
    % Align the foot to make the foreword part in balance
    x = round(max(points(:,1))*0.65);
    y1 = points(find(round(points(:,1))==x-2),2);y2 = points(find(round(points(:,1))==x),2);y3 = points(find(round(points(:,1))==x+2),2);y4 = points(find(round(points(:,1))==x+1),2);y5 = points(find(round(points(:,1))==x-1),2);
    y = cat(1,y1,y2,y3,y4,y5); y_min = min(y);y_max = max(y); y = cat(1,y_min,y_max);
    dis = (y_max - y_min)/2 + y_min;
    angle = atand(dis/x);
    threshold = 0.01;
    while abs(angle)>threshold
        [points] = CenterParallel_perform(points,[0,0,0],angle);
        x = round(max(points(:,1))*0.73);
        y1 = points(find(round(points(:,1))==x-2),2);y2 = points(find(round(points(:,1))==x),2);y3 = points(find(round(points(:,1))==x+2),2);y4 = points(find(round(points(:,1))==x+1),2);y5 = points(find(round(points(:,1))==x-1),2);
        y = cat(1,y1,y2,y3,y4,y5); y_min = min(y);y_max = max(y); y = cat(1,y_min,y_max);
        dis = (y_max - y_min)/2 + y_min;
        angle = atand(dis/x);
        disp("angle "+angle+'!!!');
    end

    [points] = moveToOrigin(points);

else
    [points] = moveToOrigin(points);
    % Align the foot to make the foreword part in balance
    x = round(max(points(:,1))*0.65);
    y1 = points(find(round(points(:,1))==x-2),2);y2 = points(find(round(points(:,1))==x),2);y3 = points(find(round(points(:,1))==x+2),2);y4 = points(find(round(points(:,1))==x+1),2);y5 = points(find(round(points(:,1))==x-1),2);
    y = cat(1,y1,y2,y3,y4,y5); y_min = min(y);y_max = max(y); y = cat(1,y_min,y_max);
    dis = (y_max - y_min)/2 + y_min;
    angle = atand(dis/x);
    threshold = 0.01;
    while abs(angle)>threshold
        [points] = CenterParallel_perform(points,[0,0],angle);
        x = round(max(points(:,1))*0.73);
        y1 = points(find(round(points(:,1))==x-2),2);y2 = points(find(round(points(:,1))==x),2);y3 = points(find(round(points(:,1))==x+2),2);y4 = points(find(round(points(:,1))==x+1),2);y5 = points(find(round(points(:,1))==x-1),2);
        y = cat(1,y1,y2,y3,y4,y5); y_min = min(y);y_max = max(y); y = cat(1,y_min,y_max);
        dis = (y_max - y_min)/2 + y_min;
        angle = atand(dis/x);
        disp("angle "+angle+'!!!');
    end

    [points] = moveToOrigin(points);
end

