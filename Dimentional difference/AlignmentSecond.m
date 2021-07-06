function [ptCloud] = AlignmentSecond(ptCloud)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
%% Alignment
% Check the angle and rotate the points untill it satisfied the threshold
% Insert the points into the model to guratee the uniform
% Align the foot throw the heel center line
distanceTOxyplane = 25;
points = ptCloud.Location(find(ptCloud.Location(:,3)<=distanceTOxyplane),:);
fullPoints = ptCloud.Location;


[s,p] = CenterParallel_check(points);   
heel_point = [0,polyval(p,0),0];
threshold = 0.05; timer = 0;
while abs(s)>threshold
    % Rotate the points
    fullPoints = CenterParallel_perform(fullPoints,heel_point,asind(s/1));
    points = CenterParallel_perform(points,heel_point,asind(s/1));
    points = points(find(points(:,3)<=distanceTOxyplane),:);
    %figure(100);hold on;
    %plot(heel_point(1),heel_point(2),'o','MarkerSize',10);
    [s,p] = CenterParallel_check(points);
    heel_point = [0,polyval(p,0),0];
    timer= timer+1;
    if(timer==20) 
       break;
    end
end
ptCloud = pointCloud(moveToOrigin(fullPoints));
end


