function [points] = Boundary_feedback_grid(points)
%UNTITLED6 此处显示有关此函数的摘要
%   此处显示详细说明
upper_boundary =[];lower_boundary=[];
point_length = round(max(points(:,1)) - min(points(:,1)));
points_body = points(find((points(:,1)>=point_length*0.05)&(points(:,1)<=point_length*0.95)),:);
points_toe_heel = points(find((points(:,1)<length(points(:,1))*0.05)|(points(:,1)>length(points(:,1))*0.95)),:);
points_body = cat(2,points_body,round(points_body(:,1)));
points_toe_heel = cat(2,points_toe_heel,round(points_toe_heel(:,2)));

for slice =floor(min(points_body(:,1))):ceil(max(points_body(:,1)))
    points_idx = find(points_body(:,3) == slice);
    if isempty(points_idx)
        continue;
    else
        points_slice = points_body(points_idx,:);
        [~,idx_max_one] = max(points_slice(:,2));
        [~,idx_min_one] = min(points_slice(:,2));
        %plot(slice,points_y_max,'*g','MarkerSize',5);
        %plot(slice,points_y_min,'*g','MarkerSize',5);
        %grid on; axis equal;
        
        upper_boundary = cat(1,upper_boundary,points_slice(idx_max_one,1:2));
        lower_boundary = cat(1,lower_boundary,points_slice(idx_min_one,1:2));

    end
  
end

for slice =floor(min(points_toe_heel(:,2))):ceil(max(points_toe_heel(:,2)))
    points_idx = find(round(points_toe_heel(:,2)) == slice);
    if isempty(points_idx)
        continue;
    else
        points_slice = points_toe_heel(points_idx,:);
        [points_y_max,idx_max_one] = max(points_slice(:,1));
        [points_y_min,idx_min_one] = min(points_slice(:,1));
        %plot(points_y_max,slice,'*g','MarkerSize',5);
        %plot(points_y_min,slice,'*g','MarkerSize',5);
        %grid on; axis equal;
        
        upper_boundary = cat(1,upper_boundary,points_slice(idx_max_one,1:2));
        lower_boundary = cat(1,lower_boundary,points_slice(idx_min_one,1:2));

    end
   
points = cat(1,lower_boundary,upper_boundary);
end

    



