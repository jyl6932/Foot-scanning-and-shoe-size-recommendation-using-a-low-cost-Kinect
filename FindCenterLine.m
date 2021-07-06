function [center_points,first_center_point] = FindCenterLine(pointsOri)
%UNTITLED5 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
dimSize = size(pointsOri);
if(dimSize(2)==4)
    idx = [];mean_points =[];
    ptCloud = pointCloud(pointsOri(:,1:3));
    length = ptCloud.XLimits(2);
    for slice = 0:length*0.13
        points_idx_new = find(pointsOri(:,4) == slice);
        if isempty(points_idx_new)
            continue;
        else
            points = pointsOri(points_idx_new,:);
            points_y_max= max(points(:,2));
            points_y_min = min(points(:,2));
            
            idx = [idx;slice];
            mean_points = [mean_points ;(points_y_max+points_y_min)/2];

        end

    end

    center_points = [idx mean_points ];
    %plot(center_points(:,1),center_points(:,2),'*r','MarkerSize',5);
    first_center_point = center_points(1,:);
    
    
elseif (dimSize(2)==3)
    idx = [];
    mean_points = [];
    %DrawBoundary(points_xy);
    length = max(pointsOri(:,1))-min(pointsOri(:,1));
    for slice = 0:length*0.13
        points_idx_new = find(pointsOri(:,3) == slice);
        if isempty(points_idx_new)
            continue;
        else
            points = pointsOri(points_idx_new,:);
            points_y_max= max(points(:,2));
            points_y_min = min(points(:,2));
            figure(100);hold on;
            plot(slice,points_y_min,'*r','MarkerSize',5);
            plot(slice,points_y_max,'*r','MarkerSize',5);
            idx = [idx;slice];
            mean_points = [mean_points ;(points_y_max+points_y_min)/2];

        end

    end

    center_points = [idx mean_points ];
    %plot(center_points(:,1),center_points(:,2),'*r','MarkerSize',5);
    first_center_point = center_points(1,:);
    

elseif (dimSize(2)==2)
    idx = [];
    mean_points = [];
    pointsOri(:,3) = round(pointsOri(:,1));
    %DrawBoundary(points_xy);
    length = max(pointsOri(1,:))-min(pointsOri(1,:));
    for slice = 0:length*0.13
        points_idx_new = find(pointsOri(:,3) == slice);
        if isempty(points_idx_new)
            continue;
        else
            points = pointsOri(points_idx_new,:);
            points_y_max= max(points(:,2));
            points_y_min = min(points(:,2));
            figure(100);hold on;
            plot(slice,points_y_min,'*r','MarkerSize',5);
            plot(slice,points_y_max,'*r','MarkerSize',5);
            idx = [idx;slice];
            mean_points = [mean_points ;(points_y_max+points_y_min)/2];

        end

    end

    center_points = [idx mean_points ];
    %plot(center_points(:,1),center_points(:,2),'*r','MarkerSize',5);
    first_center_point = center_points(1,:);
    
end
    

end

