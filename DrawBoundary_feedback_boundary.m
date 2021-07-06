function [upper_boundary, lower_boundary] = DrawBoundary_feedback_boundary(points,aa)
%Input point(x,y,z) and the direction which you want to project the
%boundary
%   此处显示详细说明
Xlength = max(points(:,1));
 upper_boundary =[];lower_boundary=[];
for slice = 1:Xlength
    points_idx = find(points(:,1) > slice & points(:,1) <=slice+1);
    if isempty(points_idx)
        continue;
    else
        points_slice = points(points_idx,:);
        [points_y_max,idx_max_one] = max(points_slice(:,aa));
        [points_y_min,idx_min_one] = min(points_slice(:,aa));
        grid on; axis equal;hold on;
        
        upper_boundary = cat(1,upper_boundary,points_slice(idx_max_one,:));
        lower_boundary = cat(1,lower_boundary,points_slice(idx_min_one,:));

    end
    
end

    

end

