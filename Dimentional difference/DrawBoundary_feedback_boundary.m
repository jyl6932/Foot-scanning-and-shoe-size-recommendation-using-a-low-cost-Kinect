function [upper_boundary, lower_boundary] = DrawBoundary_feedback_boundary(points,aa)
%Input point(x,y,z) and the direction which you want to project the
%boundary
%   此处显示详细说明
ptCloud = pointCloud(points); upper_boundary =[];lower_boundary=[];
points(:,1) = round(points(:,1)*10);
for slice = 0:ptCloud.XLimits(2)*10
    points_idx = find(points(:,1) == slice);
    if isempty(points_idx)
        continue;
    else
        points_slice = points(points_idx,:);
        [points_y_max,idx_max_one] = maxk(points_slice(:,aa),3);
        [points_y_min,idx_min_one] = mink(points_slice(:,aa),3);
        %grid on; axis equal;
        
        upper_boundary = cat(1,upper_boundary,[points_slice(idx_max_one,1)/10,points_slice(idx_max_one,2:3)]);
        lower_boundary = cat(1,lower_boundary,[points_slice(idx_min_one,1)/10,points_slice(idx_min_one,2:3)]);

    end
    
end
    upper_boundary = pcdenoise(pointCloud(upper_boundary), 'NumNeighbors',10, 'Threshold',0.1);
    lower_boundary = pcdenoise(pointCloud(lower_boundary), 'NumNeighbors',10, 'Threshold',0.1);
    upper_boundary=upper_boundary.Location;
    lower_boundary=lower_boundary.Location;
        %{
        figure(30);hold on;
        plot(upper_boundary(:,1),upper_boundary(:,2),'*r','MarkerSize',5);
        plot(lower_boundary(:,1),lower_boundary(:,2),'*b','MarkerSize',5);
        %}
    %{
    upper_boundary = pcdenoise(pointCloud(upper_boundary), 'NumNeighbors',100, 'Threshold',0.1);
    lower_boundary = pcdenoise(pointCloud(lower_boundary), 'NumNeighbors',100, 'Threshold',0.1);
    upper_boundary=upper_boundary.Location;
    lower_boundary=lower_boundary.Location;
    %}
end

