function [upper_boundary, lower_boundary] = DrawBoundary_feedback_boundary_X(points,aa)
%Input point(x,y,z) and the direction which you want to project the
%boundary
%   此处显示详细说明
ptCloud = pointCloud(points); upper_boundary =[];lower_boundary=[];
for slice = ptCloud.YLimits(1):ptCloud.YLimits(2)
    points_idx = find(round(points(:,2)) == slice);
    if isempty(points_idx)
        continue;
    else
        points_slice = points(points_idx,:);
        [points_y_max,idx_max_one] = max(points_slice(:,aa));
        [points_y_min,idx_min_one] = min(points_slice(:,aa));
        %figure(1);hold on;
        %plot(slice,points_y_max,'*g','MarkerSize',5);
        %plot(slice,points_y_min,'*g','MarkerSize',5);
        %grid on; axis equal;
        
        upper_boundary = cat(1,upper_boundary,points_slice(idx_max_one,:));
        lower_boundary = cat(1,lower_boundary,points_slice(idx_min_one,:));

    end
    
end

    upper_boundary = pcdenoise(pointCloud(upper_boundary), 'NumNeighbors',100, 'Threshold',0.1);
    lower_boundary = pcdenoise(pointCloud(lower_boundary), 'NumNeighbors',100, 'Threshold',0.1);
    upper_boundary=upper_boundary.Location;
    lower_boundary=lower_boundary.Location;
    

end

