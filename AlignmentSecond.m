function [points] = AlignmentSecond(splineXY_foot)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
%% Alignment
% Check the angle and rotate the points untill it satisfied the threshold
% Insert the points into the model to guratee the uniform
% Align the foot throw the heel center line
index = round(splineXY_foot(:,1));
points_withIndex = cat(2,splineXY_foot,index);
col_size = size(points_withIndex); col_size = col_size(2);

%% 2D points data with index
if(col_size==3)
    [angle,p] = CenterParallel_check(points_withIndex);   
    heel_point = [0,polyval(p,0),0];
    threshold = 0.01;
    while abs(angle)>threshold
        % Rotate the points
        points_withIndex = CenterParallel_perform(points_withIndex,heel_point(1:2),angle);
        %figure(3);hold on;
        %plot(heel_point(1),heel_point(2),'o','MarkerSize',10);
        [angle,p] = CenterParallel_check(points_withIndex);
    end

    points = points_withIndex(:,1:2);
    [points] = moveAlign(points,heel_point);
    
elseif (col_size==4)
    [angle,p] = CenterParallel_check(points_withIndex);   
    heel_point = [0,polyval(p,0),0];
    threshold = 0.01;
    while abs(angle)>threshold
        % Rotate the points
        points_withIndex = CenterParallel_perform(points_withIndex,heel_point,angle);
        %figure(3);hold on;
        %plot(heel_point(1),heel_point(2),'o','MarkerSize',10);
        [angle,p] = CenterParallel_check(points_withIndex);
    end

    points = points_withIndex(:,1:3);
    [points] = moveAlign(points,heel_point);

        
        
end
end


