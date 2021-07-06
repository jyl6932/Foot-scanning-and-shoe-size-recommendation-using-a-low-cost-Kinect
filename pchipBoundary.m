function [areaOfPolygon,areaInsideSplineCurve,splineXY] = pchipBoundary(points)
%UNTITLED5 此处显示有关此函数的摘要
%   此处显示详细说明
workspace;  % Make sure the workspace panel is showing.
ptCloud = pointCloud(points);

boundary_data_x = double(points(:,1));
boundary_data_y = double(points(:,2));
k = boundary(boundary_data_x,boundary_data_y,0.5);
outline = cat(2,boundary_data_x(k,:),boundary_data_y(k,:));

x = outline(:,1)';
y = outline(:,2)';
% Append first point to last to close the curve
x = [x, x(1)];
y = [y, y(1)];


% Calculate the area within the blue spline curve.
% You do not need to connect the last point back to the first point.
knots = [x; y];
areaOfPolygon = polyarea(x,y);
numberOfPoints = length(x);
% Interpolate with a spline curve and finer spacing.
originalSpacing = 1 : numberOfPoints;
% Make 9 points in between our original points that the user clicked on.
finerSpacing = 1 : 0.1 : numberOfPoints;
% Do the spline interpolation.
splineXY = pchip(originalSpacing, knots, finerSpacing);
areaInsideSplineCurve = polyarea(x,y);
%{
boundary_data_x = splineXY(1, :)';
boundary_data_y = splineXY(2, :)';
k = boundary(boundary_data_x,boundary_data_y,0.5);
outline = cat(2,boundary_data_x(k,:),boundary_data_y(k,:));

%hold on;plot(outline(:,1), outline(:,2), 'r*');

x = outline(:,1)';
y = outline(:,2)';

% Append first point to last to close the curve
x = [x, x(1)];
y = [y, y(1)];


% Calculate the area within the blue spline curve.
% You do not need to connect the last point back to the first point.
knots = [x; y];
areaOfPolygon = polyarea(x,y);
numberOfPoints = length(x);
% Interpolate with a spline curve and finer spacing.
originalSpacing = 1 : numberOfPoints;
% Make 9 points in between our original points that the user clicked on.
finerSpacing = 1 : 0.001 : numberOfPoints;
% Do the spline interpolation.
splineXY = pchip(originalSpacing, knots, finerSpacing);



% Calculate the area within the blue spline curve.
% You do not need to connect the last point back to the first point.
x = splineXY(1, :);
y = splineXY(2, :);
areaInsideSplineCurve = polyarea(x,y);
%}

end

