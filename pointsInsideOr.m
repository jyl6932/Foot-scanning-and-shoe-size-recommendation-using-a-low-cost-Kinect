function [pointsInsideMark] = pointsInsideOr(points_foot,points_shoe)

pointsInsideMark = [];Mark = 0;
for slice =1:length(points_foot)
    points_idx = find(abs(points_shoe(:,1) - points_foot(slice,1))<0.75);
    if length(points_idx)==0||length(points_idx)==1
        continue;
    else
        points_slice = points_shoe(points_idx,:);
        [points_y_max,idx_max_one] = max(points_slice(:,2));
        [points_y_min,idx_min_one] = min(points_slice(:,2));
        if  (abs(points_foot(slice,2) - points_y_max)<0.001)||(abs(points_foot(slice,2) - points_y_min)<0.001)
            Mark = 1;
        elseif (points_y_max > points_foot(slice,2))&& (points_foot(slice,2)> points_y_min)
            Mark = 1;
        elseif (points_y_max >= points_y_min) && (points_y_min > points_foot(slice,2))
            Mark = 0;
        elseif (points_foot(slice,2)> points_y_max) && ( points_y_max >= points_y_min )
            Mark = 0;
        else
            Mark = Mark; 
        end
        temp = cat(2,slice,Mark);
        pointsInsideMark = cat(1,pointsInsideMark,temp);

    end

end

