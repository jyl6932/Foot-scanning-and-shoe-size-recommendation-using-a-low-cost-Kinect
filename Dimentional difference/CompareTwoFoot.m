Path_48108 =  'F:\A_Jin Yiling\Trail\ShoeFootEXP0922_Final\Scan\RussaFoot\48108\right.obj';

Path_47129 =  'F:\A_Jin Yiling\Trail\ShoeFootEXP0922_Final\Scan\RussaFoot\47129\right.obj';

foot_48108 = readObj(Path_48108);
foot_47129 = readObj(Path_47129);

PointCloud_48108 = foot_48108.v;
PointCloud_47129 = foot_47129.v;

bottom_48108 = PointCloud_48108(find(PointCloud_48108(:,3)<20),:);
bottom_47129 = PointCloud_47129(find(PointCloud_47129(:,3)<20),:);

figure;hold on;axis equal;
scatter3(PointCloud_48108(:,1),PointCloud_48108(:,2),PointCloud_48108(:,3),'ro');
scatter3(PointCloud_47129(:,1),PointCloud_47129(:,2),PointCloud_47129(:,3),'b*');