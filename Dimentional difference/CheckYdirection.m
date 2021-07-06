function [ptCloud_rotated] = CheckYdirection(data)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
ptCloud_rotated= pointCloud(data);

TOxyplane = 30;
data_TOxyplane = ptCloud_rotated.Location(find(ptCloud_rotated.Location(:,3)<TOxyplane),:);
x_forward_groups = data_TOxyplane(find((data_TOxyplane(:,1)>ptCloud_rotated.XLimits(2)*0.75)&(data_TOxyplane(:,1)<ptCloud_rotated.XLimits(2)*0.8)),:);
x_heel_groups = data_TOxyplane(find((data_TOxyplane(:,1)>ptCloud_rotated.XLimits(2)*0.15)&(data_TOxyplane(:,1)<ptCloud_rotated.XLimits(2)*0.2)),:);
forward_groups_minman_y = max(x_forward_groups(:,2))-min(x_forward_groups(:,2));
x_heel_groups_y = max(x_heel_groups(:,2))-min(x_heel_groups(:,2));
flag = x_heel_groups_y-forward_groups_minman_y;
if flag>1
    data(:,1) = -data(:,1) + ptCloud_rotated.XLimits(2);
    disp('wrong x direction');
end  

ptCloud_rotated= pointCloud(data);
left_y_points =  ptCloud_rotated.Location(find(ptCloud_rotated.Location(:,2)>ptCloud_rotated.YLimits(2)*0.5),:);
right_y_points =  ptCloud_rotated.Location(find(ptCloud_rotated.Location(:,2)<ptCloud_rotated.YLimits(2)*0.5),:);

left_y_ptCloud = pointCloud(left_y_points);
right_y_ptCloud = pointCloud(right_y_points);

right_length = left_y_ptCloud.XLimits(2)-left_y_ptCloud.XLimits(1);
left_length = right_y_ptCloud.XLimits(2)-right_y_ptCloud.XLimits(1);

if ( right_length(1) > left_length(1))
    data = cat(2,data(:,1),-data(:,2),data(:,3));
    [data] = NormalPC(data);
    disp('wrong y direction')
    ptCloud_rotated = pointCloud(data);
else
end


