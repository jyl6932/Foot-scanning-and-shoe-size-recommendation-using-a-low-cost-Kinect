function [pointsRoated] = CenterParallel_perform(points,heel_point,angle)
%UNTITLED4 此处显示有关此函数的摘要
%   此处显示详细说明
%% 8) Rotate the foot around the heel points and make the center line parallel to the X-axis
% transplant to the [0 0 0] first, rotate with angle along the z-axis and
% move back

size_point = size(points);col_num = size_point(2);
if col_num==4
    transplant = heel_point;
    rotation_matrix =  [cosd(-angle) sind(-angle) 0;-sind(-angle) cosd(-angle) 0;0 0 1];

    points_move = points(:,1:3) - transplant;
    points_rotate = points_move*rotation_matrix;
    pointsRoated = points_rotate;
    pointsRoated(:,4) = points(:,4);
    %[points_gourp_back] = NormalPC(points_gourp_back);
    %points_move_back = cat(2,points_gourp_back(1:end-1,:), points(:,4));
    %heel_point_update = points_gourp_back(end,:);

elseif (col_num==3)
    transplant = heel_point;
    rotation_matrix = [cosd(-angle) sind(-angle) 0;-sind(-angle) cosd(-angle) 0;0 0 1];

    points_move = points - transplant;
    points_rotate = points_move*rotation_matrix;
    pointsRoated = points_rotate;
    
elseif (col_num==2)
    transplant = heel_point(1:2);
    rotation_matrix =  [cosd(-angle) sind(-angle) 0;-sind(-angle) cosd(-angle) 0];

    points_move = points(:,1:2) - transplant;
    points_rotate = points_move*rotation_matrix;
    pointsRoated = points_rotate;
end

end

