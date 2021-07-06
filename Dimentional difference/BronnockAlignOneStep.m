function [diff,rotatedptCloud] = BronnockAlignOneStep(ptCloud)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
%% Extract potential landmark id based on color image
[colorPoints,~] = ColorExtractLandmark(ptCloud);
% Extract potential landmark location information based on color image
colorPoints = pcdenoise(pointCloud(colorPoints));
%% First metatarsal bone
metatarsalPoints_groups = colorPoints.Location(find((colorPoints.Location(:,1)>=ptCloud.XLimits(2)*0.65)&(colorPoints.Location(:,1)<=ptCloud.XLimits(2)*0.85)),:);
metatarsalPoints_inside_groups = metatarsalPoints_groups(find(metatarsalPoints_groups(:,2)<ptCloud.YLimits(1)*0.50),:);
metatarsalPoints_outside_groups = metatarsalPoints_groups(find(metatarsalPoints_groups(:,2)>ptCloud.YLimits(2)*0.9),:);
%{
first_metatarsal_inside_groups = metatarsalPoints_inside_groups(find(metatarsalPoints_inside_groups(:,2)>ptCloud.YLimits(2)*0.9),:);
first_upper_inside_groups = metatarsalPoints_inside_groups(find(metatarsalPoints_inside_groups(:,2)<ptCloud.YLimits(2)*0.9),:);

first_metatarsal_point = selectCenterPoint(first_metatarsal_inside_groups);
first_upper_point = selectCenterPoint(first_upper_inside_groups);
fifth_metatarsal_point = selectCenterPoint(metatarsalPoints_outside_groups);
%}

[labels,numClusters] = pcsegdist(pointCloud(metatarsalPoints_inside_groups),5);

sizeCollection = [];
while(numClusters>0)
    group = metatarsalPoints_inside_groups(find(labels==numClusters),:);
    temp = [size(group,1),numClusters];
    sizeCollection = [sizeCollection;temp];
    numClusters = numClusters-1;
end
sortedSize = sortrows(sizeCollection,1);
out = sortedSize([end-1,end],2)

first_metatarsal_point_group = metatarsalPoints_inside_groups(find(labels==out(1)),:);
first_upper_point_group = metatarsalPoints_inside_groups(find(labels==out(2)),:);

first_upper_point = selectCenterPoint(first_metatarsal_point_group);
first_metatarsal_point = selectCenterPoint(first_upper_point_group);
fifth_metatarsal_point = selectCenterPoint(metatarsalPoints_outside_groups);

if(first_metatarsal_point(2)>first_upper_point(2))
    temp = first_metatarsal_point;
    first_metatarsal_point = first_upper_point;
    first_upper_point = temp;
end



figure(20);hold on;
pcshow(ptCloud);hold on;
plot3(colorPoints.Location(:,1),colorPoints.Location(:,2),colorPoints.Location(:,3),'o','Color','g','MarkerSize',1);
%% Ankle points inside/outside
anklePoints_groups = colorPoints.Location(find(colorPoints.Location(:,1)<=ptCloud.XLimits(2)*0.40),:);
anklePoints_outside_groups = anklePoints_groups(find(anklePoints_groups(:,2)>ptCloud.YLimits(2)*0.50),:);
anklePoints_inside_groups = anklePoints_groups(find(anklePoints_groups(:,2)<ptCloud.YLimits(2)*0.50),:);
ankle_inside_point = selectCenterPoint(anklePoints_inside_groups);
ankle_outside_point = selectCenterPoint(anklePoints_outside_groups);

plot3(anklePoints_inside_groups(:,1),anklePoints_inside_groups(:,2),anklePoints_inside_groups(:,3),'o','Color','b','MarkerSize',5);
plot3(anklePoints_outside_groups(:,1),anklePoints_outside_groups(:,2),anklePoints_outside_groups(:,3),'o','Color','r','MarkerSize',5);
plot3(ankle_inside_point(:,1),ankle_inside_point(:,2),ankle_inside_point(:,3),'o','Color','g','MarkerSize',15);
plot3(ankle_outside_point(:,1),ankle_outside_point(:,2),ankle_outside_point(:,3),'o','Color','g','MarkerSize',15)
plot3(anklePoints_groups(:,1),anklePoints_groups(:,2),anklePoints_groups(:,3),'o','Color','b','MarkerSize',5);
plot3(first_metatarsal_point_group(:,1),first_metatarsal_point_group(:,2),first_metatarsal_point_group(:,3),'o','Color','b','MarkerSize',5);
plot3(first_upper_point_group(:,1),first_upper_point_group(:,2),first_upper_point_group(:,3),'o','Color','r','MarkerSize',5);
plot3(first_metatarsal_point(1),first_metatarsal_point(2),first_metatarsal_point(3),'o','Color','r','MarkerSize',15);
plot3(first_upper_point(1),first_upper_point(2),first_upper_point(3),'o','Color','g','MarkerSize',15);
plot3(fifth_metatarsal_point (1),fifth_metatarsal_point (2),fifth_metatarsal_point (3),'o','Color','b','MarkerSize',15)


%% Alignment
pointsBottom = ptCloud.Location(find(ptCloud.Location(:,3)<25),:);
[upper_boundary, lower_boundary] = DrawBoundary_feedback_boundary(pointsBottom,2);

[~,idxUpper] = sort(upper_boundary(:,1),'descend');
[~,idxLower] = sort(lower_boundary(:,1));
sortedUpper = upper_boundary(idxUpper,:);
sortedLower = lower_boundary(idxLower,:);
sortedOutliness = [sortedUpper;sortedLower];
sortedOutline = sortedOutliness(find(sortedOutliness(:,1)<30),:);

%% Calculate p
X = sortedOutline(:,2);
Y = sortedOutline(:,1);

p = polyfit(X,Y,2);
a = p(1);b = p(2); c = p(3);
x_p = 0;y_p = 0;
d_pM1 = sqrt((x_p-first_metatarsal_point(2))^2+(y_p-first_metatarsal_point(1))^2);
d_M1 = abs(x_p-first_metatarsal_point(2));
diff = d_M1-38.1
angle = -asind(d_M1/d_pM1) + asind(38.1/d_pM1);

figure(20);hold on;
plot(sortedOutliness(:,1),sortedOutliness(:,2));
plot(y_p,x_p,'o','Color','g','MarkerSize',5);
plot(first_metatarsal_point(:,1),-38.1,'o','Color','r','MarkerSize',10);
plot(first_metatarsal_point(:,1),first_metatarsal_point(:,2),'o','Color','g','MarkerSize',10);

%% transplant to the [0 0 0] first, rotate with angle along the z-axis and
% move back
points = ptCloud.Location;
points(:,1) =  points(:,1)-y_p;
points(:,2) =  points(:,2)-x_p;
rotation_matrix = [cosd(angle) -sind(angle) 0;sind(angle) cosd(angle) 0;0 0 1];

rotatedPoints = points*rotation_matrix;
rotatedptCloud = pointCloud(moveToOrigin(rotatedPoints));

end

