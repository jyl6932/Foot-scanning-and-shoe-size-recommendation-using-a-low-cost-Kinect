function [center_points,first_center_point] = FindCenterLine(pointsOri)
%UNTITLED5 此处显示有关此函数的摘要
%   此处显示详细说明
dimSize = size(pointsOri);

%% 3D points data (with index)
if(dimSize(2)==4)
    idx = [];mean_points =[];
    ptCloud = pointCloud(pointsOri(:,1:3));
    length = ptCloud.XLimits(2);
    for slice = 0:length*0.13*20
        points_idx_new = find(pointsOri(:,4)*20 == slice);
        if isempty(points_idx_new)
            continue;
        else
            points = pointsOri(points_idx_new,:);
            points_y_max= max(points(:,2));
            points_y_min = min(points(:,2));
            %figure(100);hold on;
            %plot(slice,points_y_min,'*r','MarkerSize',5);
            %plot(slice,points_y_max,'*r','MarkerSize',5);            
            idx = [idx;slice];
            mean_points = [mean_points ;(points_y_max+points_y_min)/2];

        end

    end

    center_points = [idx mean_points ];
    %plot(center_points(:,1),center_points(:,2),'*r','MarkerSize',5);
    first_center_point = center_points(1,:);
    
%% 2D points data ( projected & with Index )  
elseif (dimSize(2)==3)
    idx = [];
    mean_points = [];
    %DrawBoundary(points_xy);
    length = max(pointsOri(:,1))-min(pointsOri(:,1));
    for slice = 0:length*0.13*20
        points_idx_new = find(round(pointsOri(:,1))*20 == slice);
        if isempty(points_idx_new)
            continue;
        else
            points = pointsOri(points_idx_new,:);
            points_y_max= max(points(:,2));
            points_y_min = min(points(:,2));
            %figure(100);hold on;
            %plot(slice,points_y_min,'*r','MarkerSize',5);
            %plot(slice,points_y_max,'*r','MarkerSize',5);
            idx = [idx;slice];
            mean_points = [mean_points ;(points_y_max+points_y_min)/2];

        end

    end

    center_points = [idx mean_points ];
    %plot(center_points(:,1),center_points(:,2),'*r','MarkerSize',5);
    first_center_point = center_points(1,:);
    
   
end

