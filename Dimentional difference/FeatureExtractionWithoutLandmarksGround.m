function [features] = FeatureExtractionWithoutLandmarksGround(ptCloud,FileName)
distanceTOxyplane = 25;
points_25 = ptCloud.Location(find(ptCloud.Location(:,3)<=distanceTOxyplane),:);
ptCloud25 = pointCloud(points_25);

distanceTOxyplane = 20;
points_20 = ptCloud.Location(find(ptCloud.Location(:,3)<=distanceTOxyplane),:);
%% Dorsal arch point == orginal P3 ( dorsal arch at 50% of the FL ) (49.5% -50.5% maximum point)
points_dorsal_gourps = ptCloud.Location(find((ptCloud.Location(:,1)<ptCloud.XLimits(2)*0.5+2.5)&(ptCloud.Location(:,1)>ptCloud.XLimits(2)*0.5-2.5)),:);
[points_dorsal_point, dorsal_point_idx] =maxk(points_dorsal_gourps(:,3),5);
points_dorsal_point = points_dorsal_gourps(dorsal_point_idx,:);

P1= median(points_dorsal_point);

%% P2: minimum P1P2 distance as control points P2
[upper_boundary, lower_boundary]=DrawBoundary_feedback_boundary(points_20,2);
P2_groups = upper_boundary(find((ptCloud.XLimits(2)*0.25<=upper_boundary(:,1))&(upper_boundary(:,1)<=ptCloud.XLimits(2)*0.45)),:);
points_group = [P2_groups(:,1) P2_groups(:,2)];
min_idx = matchest(points_group,P1(1:2));
P2 = P2_groups(min_idx,:);

%% 40mm 1st & 2nd
[upper_boundary, lower_boundary]=DrawBoundary_feedback_boundary(points_20,2);
groupUpper = upper_boundary(find((upper_boundary(:,1) >= 38.5) & (upper_boundary(:,1) <= 41.5) ),:);
groupLower = lower_boundary(find((lower_boundary(:,1) >= 38.5) & (lower_boundary(:,1) <= 41.5) ),:);
groupUpper = groupUpper(find(groupUpper(:,2)>0),:);
groupLower = groupLower(find(groupLower(:,2)<0),:);
first_40mm = median(maxk(groupUpper(:,2),3)); 
second_40mm = median(mink(groupLower(:,2),3));
%% arch point == orginal P1 截取脚后跟30（x）处大于y的教，再截取x轴0.35-0.60处的脚
%{
distanceTOxyplane = 10;
points_15 = ptCloud.Location(find(ptCloud.Location(:,3)<=distanceTOxyplane),:);

[upper_boundary, ~]=DrawBoundary_feedback_boundary(points_15 ,3);
arch_points_groups = upper_boundary(find((ptCloud.XLimits(2)*0.35<=upper_boundary(:,1))&(upper_boundary(:,1)<=ptCloud.XLimits(2)*0.60)&(upper_boundary(:,2)<0)),:);
[P3] = ChoosePoint(P1,P2,arch_points_groups,ptCloud);
%}
[upper_boundary, lower_boundary]=DrawBoundary_feedback_boundary(points_20 ,3);
arch_points_groups = upper_boundary(find((ptCloud.XLimits(2)*0.35<=upper_boundary(:,1))&(upper_boundary(:,1)<=ptCloud.XLimits(2)*0.60)&(upper_boundary(:,2)<0)),:);
[P3] = ChoosePoint(P1,P2,arch_points_groups,ptCloud);
%% P4 

%P4PreGroup = pointCloud(ptCloud15.Location(find((0<=ptCloud15.Location(:,1))&(ptCloud15.Location(:,1)<=ptCloud.XLimits(2)*0.035)),:));
distanceTOxyplane = 10;
points_10 = ptCloud.Location(find(ptCloud.Location(:,3)<=distanceTOxyplane),:);
[~,p] = CenterParallel_check(ptCloud.Location);
heel_point = [median(mink(points_10(:,1),3)),polyval(p,0),5];
[P4] = heel_point;
%{
[upper_boundary, lower_boundary] = DrawBoundary_feedback_boundary(points_20,3);
P4_groups = lower_boundary(find((0<=lower_boundary(:,1))&(lower_boundary(:,1)<=ptCloud.XLimits(2)*0.035)),:);
[P4] = ChoosePointPer(P3,P4_groups,ptCloud);
%}
%% P6
[upper_boundary, lower_boundary] = Boundary_feedback_boundary(ptCloud.Location,3);
P6_groups = upper_boundary(find((ptCloud.XLimits(2)*0.37<=upper_boundary(:,1))&(upper_boundary(:,1)<=ptCloud.XLimits(2)*0.5)),:);
%plot3(P6_groups(:,1),P6_groups(:,2),P6_groups(:,3),'o','MarkerSize',10);
[P6] = ChoosePointPer(P4,P6_groups,ptCloud);

% Mid-foot Width
% ExScan 0.6 0.6
midFootPoints = ptCloud.Location(find((ptCloud.Location(:,1)<ptCloud.XLimits(2)*0.5+0.6)&(ptCloud.Location(:,1)>ptCloud.XLimits(2)*0.5-0.6)),:);

%% Draw the points
figure(120);hold on;pcshow(ptCloud);
plot3(P2(1),P2(2),P2(3),'o','Color','r','MarkerSize',10);
plot3(P3(1),P3(2),P3(3),'o','Color','g','MarkerSize',10);
plot3(P1(1),P1(2),P1(3),'o','Color','r','MarkerSize',10);
plot3(P4(1),P4(2),P4(3),'o','Color','b','MarkerSize',10);
plot3(P6(1),P6(2),P6(3),'o','Color','r','MarkerSize',10);

MPJ = pointCloud(ptCloud.Location(find((ptCloud.Location(:,1)<ptCloud.XLimits(2)*0.80)&(ptCloud.Location(:,1)>ptCloud.XLimits(2)*0.65)&(ptCloud.Location(:,3)<25)),:));
%% Start the measure the characteristics
FootLength = median(maxk(ptCloud25.Location(:,1),10)) -median(mink(ptCloud25.Location(:,1),10)) 
FootWidth = median(maxk(MPJ.Location(:,2),10)) - median(mink(MPJ.Location(:,2),10)) 
%HeelToMedial = ankle_inside_point(1)
%HeelToLateral = ankle_outside_point(1)
%BimalleolarWidth = abs(ankle_inside_point(2) - ankle_outside_point(2))
MidFootWidth = median(maxk(midFootPoints(:,2),10)) -median( mink(midFootPoints(:,2),10))
%MedialHeight = ankle_inside_point(3)
%LateralHeight = ankle_outside_point(3)
MidFootHeight = median(maxk(points_dorsal_gourps(:,3),10))
InstepGirth = ConvexDistance(P1,P2,P3,ptCloud.Location)
ShortHeelGirth = ConvexDistancePerpen(P4,P6,ptCloud.Location)
LongHeelGirth = ConvexDistancePerpen(P4,P1,ptCloud.Location)
AnkleGirth = ConvexDistancePerPlane(P6,3,ptCloud.Location)
%ArchLength = first_metatarsal_point(1)
%BallGirth = ConvexDistance(first_upper_point,first_metatarsal_point,fifth_metatarsal_point,ptCloud.Location)
width_40mm = pdist([first_40mm;second_40mm],'euclidean');
features = {FileName,FootLength,FootWidth,...
         width_40mm,MidFootWidth, ...
           MidFootHeight,...
            InstepGirth,ShortHeelGirth,LongHeelGirth,AnkleGirth};
       
% Draw the foot figure and save it
footFigure = figure('NumberTitle','off','Name','Foot outline figure');hold on; axis equal;
scatter(points_20(:,1),points_20(:,2),'ro');
line([MPJ.XLimits(2) MPJ.XLimits(2)],[-100 100],'Color','blue','LineWidth',2);
line([0 250],[38.1 38.1],'Color','blue','LineWidth',2);
line([0 250],[MPJ.YLimits(2) MPJ.YLimits(2) ],'Color','red','LineWidth',2);
line([0 250],[ MPJ.YLimits(1)   MPJ.YLimits(1) ],'Color','blue','LineWidth',2);



%scatter(mean(archArea(archIdx,1)),mean(archArea(archIdx,2)),'+k','LineWidth',8);
%saveFile(footFigure,saveGraphyPath,saveFootName);
close(footFigure);

end



