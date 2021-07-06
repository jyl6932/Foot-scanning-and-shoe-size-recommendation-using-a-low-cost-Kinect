function [closestPoints,dimen_difference] = Dimensional_difference(points,outline)
%UNTITLED13 此处显示有关此函数的摘要
%   此处显示详细说明
[pointsInsideMark] = pointsInsideOr(points,outline);
pointsSelected = points(pointsInsideMark(:,1),:);
closestPoints = []; dimen_difference = [];
for slice = 1 :length(pointsSelected)
    
    point = pointsSelected(slice,:);
    if isempty(point)
        continue;
    else
        x = outline(:,1);
        y = outline(:,2);
        distances = sqrt((point(1)-x).^2 + (point(2)-y).^2);
        [minDistance,indexOfMin] = min(distances);       
        % Draw a line from the closest point to (0, 0)
        closestX = outline(indexOfMin,1);
        closestY = outline(indexOfMin,2);
        %plot(closestX, closestY, 'bo', 'MarkerSize', 1, 'LineWidth', 2);
        if pointsInsideMark(slice,2) == 0
            minDistance = -minDistance;
            line([point(1), closestX], [point(2), closestY], 'LineWidth', 2, 'Color', 'r');
        else
            line([point(1), closestX], [point(2), closestY], 'LineWidth', 2, 'Color', 'g');
        end

        closestPoints = cat(1,closestPoints,outline(indexOfMin,:));
        temp = cat(2,point,minDistance);
        dimen_difference = cat(1,dimen_difference,temp);



    end

end

end