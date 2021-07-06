function [features] = FeatureExtraction(ptCloud,FileName)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
saveGraphyPath = 'F:\A_Jin Yiling\pilot test\Results\FootGraphy'; 

%% Extract potential landmark id based on color image
[colorPoints,I] = ColorExtractLandmark(ptCloud);
% Extract potential landmark location information based on color image
colorPoints = pcdenoise(pointCloud(colorPoints), 'NumNeighbors',50, 'Threshold',0.03);
%% Dorsal arch point == orginal P3 ( dorsal arch at 50% of the FL ) (49.5% -50.5% maximum point)
points_dorsal_gourps = ptCloud.Location(find((ptCloud.Location(:,1)<ptCloud.XLimits(2)*0.505)&(ptCloud.Location(:,1)>ptCloud.XLimits(2)*0.495)),:);
[points_dorsal_point, dorsal_point_idx] =maxk(points_dorsal_gourps(:,3),5);
points_dorsal_point = points_dorsal_gourps(dorsal_point_idx,:);

P1= median(points_dorsal_point);

%% P2: minimum P1P2 distance as control points P2
distanceTOxyplane = 25;
points_20 = ptCloud.Location(find(ptCloud.Location(:,3)<=distanceTOxyplane),:);
ptCloud20 = pointCloud(points_20);

[upper_boundary, lower_boundary]=DrawBoundary_feedback_boundary(points_20,2);
P2_groups = upper_boundary(find((ptCloud.XLimits(2)*0.25<=upper_boundary(:,1))&(upper_boundary(:,1)<=ptCloud.XLimits(2)*0.45)),:);
points_group = [P2_groups(:,1) P2_groups(:,2)];
min_idx = matchest(points_group,P1(1:2));
P2 = P2_groups(min_idx,:);

%% 40mm 1st & 2nd
first_40mm = selectCenterPoint( upper_boundary(find((upper_boundary(:,1) >= 39.5) & (upper_boundary(:,1) <= 40.5) ),:));
second_40mm = selectCenterPoint(lower_boundary(find((upper_boundary(:,1) >= 39.5) & (upper_boundary(:,1) <= 40.5) ), :));

%% arch point == orginal P1 截取脚后跟30（x）处大于y的教，再截取x轴0.35-0.60处的脚
[upper_boundary, lower_boundary]=DrawBoundary_feedback_boundary(points_20 ,3);
arch_points_groups = upper_boundary(find((ptCloud.XLimits(2)*0.35<=upper_boundary(:,1))&(upper_boundary(:,1)<=ptCloud.XLimits(2)*0.60)&(upper_boundary(:,2)<0)),:);
[P3] = ChoosePoint(P1,P2,arch_points_groups,ptCloud);

%% P4 
[upper_boundary, lower_boundary] = Boundary_feedback_boundary(ptCloud.Location,3);
P4_groups = lower_boundary(find((0<=lower_boundary(:,1))&(lower_boundary(:,1)<=ptCloud.XLimits(2)*0.035)),:);
[P4] = ChoosePointPer(P3,P4_groups,ptCloud);

%% P6
[upper_boundary, lower_boundary] = Boundary_feedback_boundary(ptCloud.Location,3);
P6_groups = upper_boundary(find((ptCloud.XLimits(2)*0.37<=upper_boundary(:,1))&(upper_boundary(:,1)<=ptCloud.XLimits(2)*0.5)),:);
%plot3(P6_groups(:,1),P6_groups(:,2),P6_groups(:,3),'o','MarkerSize',10);
[P6] = ChoosePointPer(P4,P6_groups,ptCloud);

%% Ankle points inside/outside
anklePoints_groups = colorPoints.Location(find((colorPoints.Location(:,1)<=ptCloud.XLimits(2)*0.40)&(colorPoints.Location(:,1)>=ptCloud.XLimits(2)*0.15)),:);
anklePoints_outside_groups = anklePoints_groups(find(anklePoints_groups(:,2)>0),:);
anklePoints_inside_groups = anklePoints_groups(find(anklePoints_groups(:,2)<0),:);
ankle_inside_point = selectCenterPoint(anklePoints_inside_groups);
ankle_outside_point = selectCenterPoint(anklePoints_outside_groups);


figure(20);hold on;
pcshow(ptCloud);
plot3(anklePoints_inside_groups(:,1),anklePoints_inside_groups(:,2),anklePoints_inside_groups(:,3),'o','Color','b','MarkerSize',5);
plot3(anklePoints_outside_groups(:,1),anklePoints_outside_groups(:,2),anklePoints_outside_groups(:,3),'o','Color','r','MarkerSize',5);
plot3(ankle_inside_point(:,1),ankle_inside_point(:,2),ankle_inside_point(:,3),'o','Color','g','MarkerSize',15);
plot3(ankle_outside_point(:,1),ankle_outside_point(:,2),ankle_outside_point(:,3),'o','Color','g','MarkerSize',15);


%% First/Fifth metatarsal bone
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

% Mid-foot Width
midFootPoints = points_dorsal_gourps(find((points_dorsal_gourps(:,1)<ptCloud.XLimits(2)*0.5+0.6)&(points_dorsal_gourps(:,1)>ptCloud.XLimits(2)*0.5-0.6)),:);

%% Draw the points
figure(20);
plot3(first_metatarsal_point(:,1),first_metatarsal_point(:,2),first_metatarsal_point(:,3),'o','Color','g','MarkerSize',15);
plot3(first_upper_point(:,1),first_upper_point(:,2),first_upper_point(:,3),'o','Color','r','MarkerSize',15);
plot3(fifth_metatarsal_point(:,1),fifth_metatarsal_point(:,2),fifth_metatarsal_point(:,3),'o','Color','b','MarkerSize',15);
plot3(P2(1),P2(2),P2(3),'o','Color','r','MarkerSize',10)
plot3(P3(1),P3(2),P3(3),'o','Color','r','MarkerSize',10);
plot3(P1(1),P1(2),P1(3),'o','Color','r','MarkerSize',10);
plot3(P4(1),P4(2),P4(3),'o','Color','r','MarkerSize',10);
plot3(first_metatarsal_point(1),first_metatarsal_point(2),first_metatarsal_point(3),'o','Color','g','MarkerSize',10);
plot3(first_upper_point(1),first_upper_point(2),first_upper_point(3),'o','Color','b','MarkerSize',10);
plot3(fifth_metatarsal_point (1),fifth_metatarsal_point (2),fifth_metatarsal_point (3),'o','Color','r','MarkerSize',10)
plot3(P6(1),P6(2),P6(3),'o','Color','r','MarkerSize',10)
plot3(ankle_inside_point(1),ankle_inside_point(2),ankle_inside_point(3),'o','Color','g','MarkerSize',10);
plot3(ankle_outside_point(1),ankle_outside_point(2),ankle_outside_point(3),'o','Color','b','MarkerSize',10);


%% Start the measure the characteristics
FootLength = median(maxk(ptCloud20.Location(:,1),5))- median(mink(ptCloud20.Location(:,1),5)) 
FootWidth = fifth_metatarsal_point(2)-first_metatarsal_point(2);
%FootWidth = ptCloud.YLimits(2)-ptCloud.YLimits(1);
width_40mm = pdist([first_40mm;second_40mm],'euclidean');
HeelToMedial = ankle_inside_point(1)
HeelToLateral = ankle_outside_point(1)
BimalleolarWidth = abs(ankle_inside_point(2) - ankle_outside_point(2))
MidFootWidth = median(maxk(midFootPoints(:,2),5)) -median( mink(midFootPoints(:,2),5))
MedialHeight = ankle_inside_point(3)
LateralHeight = ankle_outside_point(3)
MidFootHeight = median(maxk(points_dorsal_gourps(:,3),5))
InstepGirth = ConvexDistance(P1,P2,P3,ptCloud.Location)
ShortHeelGirth = ConvexDistancePerpen(P4,P6,ptCloud.Location)
LongHeelGirth = ConvexDistancePerpen(P4,P1,ptCloud.Location)
AnkleGirth = ConvexDistancePerPlane(P6,3,ptCloud.Location)
ArchLength = first_metatarsal_point(1)
BallGirth = ConvexDistance(first_upper_point,first_metatarsal_point,fifth_metatarsal_point,ptCloud.Location)


% Save the features to the xlsx file. && foot image to check the
% features similarity
saveFootName = [FileName,'_','20'];
features = {FileName,FootLength,ArchLength,HeelToMedial,HeelToLateral,...
            FootWidth,BimalleolarWidth,MidFootWidth, width_40mm,...
            MedialHeight,LateralHeight,MidFootHeight,...
            InstepGirth,ShortHeelGirth,LongHeelGirth,AnkleGirth,BallGirth};


     
% Draw the foot figure and save it
footFigure = figure('NumberTitle','off','Name','Foot outline figure');hold on; axis equal;
scatter(points_20(:,1),points_20(:,2),'ro');
line([ptCloud.XLimits(2) ptCloud.XLimits(2)],[-100 100],'Color','blue','LineWidth',2);
line([0 250],[-38.1 -38.1],'Color','blue','LineWidth',2);
line([0 250],[fifth_metatarsal_point(2) fifth_metatarsal_point(2)],'Color','blue','LineWidth',2);

scatter(first_metatarsal_point(1),first_metatarsal_point(2), 'b')
scatter(fifth_metatarsal_point(1),fifth_metatarsal_point(2), 'b')
scatter(first_upper_point(1),first_upper_point(2), 'b')
%scatter(mean(archArea(archIdx,1)),mean(archArea(archIdx,2)),'+k','LineWidth',8);
saveFile(footFigure,saveGraphyPath,saveFootName);
close(footFigure);
%}
end

