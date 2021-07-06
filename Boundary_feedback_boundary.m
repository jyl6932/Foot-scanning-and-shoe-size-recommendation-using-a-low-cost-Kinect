function [upper_boundary, lower_boundary] = Boundary_feedback_boundary(points,aa)
%UNTITLED6 此处显示有关此函数的摘要
%   此处显示详细说明
ptCloud = pointCloud(points); upper_boundary =[];lower_boundary=[];
for slice = 1:ptCloud.XLimits(2)
    points_idx = find(points(:,1) == slice);
    if isempty(points_idx)
        continue;
    else
        points_slice = points(points_idx,:);
        [points_y_max,idx_max_one] = max(points_slice(:,aa));
        [points_y_min,idx_min_one] = min(points_slice(:,aa));
        %plot(slice,points_y_max,'*g','MarkerSize',5);
        %plot(slice,points_y_min,'*g','MarkerSize',5);
        grid on; axis equal;
        
        upper_boundary = cat(1,upper_boundary,points_slice(idx_max_one,:));
        lower_boundary = cat(1,lower_boundary,points_slice(idx_min_one,:));

    end
    
end


    

end

function [outputArg1,outputArg2] = untitled11(inputArg1,inputArg2)
%UNTITLED11 此处显示有关此函数的摘要
%   此处显示详细说明
outputArg1 = inputArg1;
outputArg2 = inputArg2;
end

