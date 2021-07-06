function [upper_boundary, lower_boundary] = Boundary_feedback_boundary(points,aa)
%UNTITLED6 此处显示有关此函数的摘要
%   此处显示详细说明
ptCloud = pointCloud(points); upper_boundary =[];lower_boundary=[];
points(:,1) = round(points(:,1));
for slice = 1:ptCloud.XLimits(2)
    points_idx = find(points(:,1) == slice);
    if isempty(points_idx)
        continue;
    else
        points_slice = points(points_idx,:);
        [points_y_max,idx_max_one] = maxk(points_slice(:,aa),3);
        [points_y_min,idx_min_one] = maxk(points_slice(:,aa),3);
        %plot(slice,points_y_max,'*g','MarkerSize',5);
        %plot(slice,points_y_min,'*g','MarkerSize',5);
        %grid on; axis equal;
        
        upper_boundary = cat(1,upper_boundary,points_slice(idx_max_one,:));
        lower_boundary = cat(1,lower_boundary,points_slice(idx_min_one,:));

    end
    
end


    

end

