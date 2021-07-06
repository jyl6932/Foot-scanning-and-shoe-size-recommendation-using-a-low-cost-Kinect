function [ptCloud_temp2] = groundPreprocessing(leftPointCloud_original)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
        ptCloud = leftPointCloud_original;
        [angleZ,rotationAxis,distance] = mirrorToGroundKinect(ptCloud);

         while(angleZ>0.01)
                    points = ptCloud.Location;
                    points = AxelRot(points', angleZ, rotationAxis,[])';
                    ptCloud = pointCloud([points(:,1:2),points(:,3) - distance]);
                    ptCloud.Color = leftPointCloud_original.Color;
                    [angleZ,rotationAxis,distance] = mirrorToGroundKinect(ptCloud);
         end
        %points = NormalPC(points);
        %ptCloud = pointCloud(points);
        upper_points_size = size(points((points(:,3)>50),:));
        lower_points_size = size(points((points(:,3)<-50),:));
        if(upper_points_size(1)<lower_points_size(1))
            points = cat(2,points(:,1:2),-points(:,3));
            disp('wrong z direction')
            [angleZ,rotationAxis,distance] = mirrorToGroundKinect(ptCloud);
            ptCloud = pointCloud([points(:,1:2),points(:,3) - distance]);
        end
        
        %ExScan 12
        footLabels = find((ptCloud.Location(:,3)>4)&(ptCloud.Location(:,3)<90)); 
        ptCloud_temp = pointCloud(ptCloud.Location(footLabels,:));
        ptCloud_temp.Color = leftPointCloud_original.Color(footLabels,:);
        
        [labels,numClusters] = pcsegdist((ptCloud_temp),10);       
        sizeCollection = [];
        while(numClusters>0)
            group = ptCloud_temp.Location(find(labels==numClusters),:);
            temp = [size(group,1),numClusters];
            sizeCollection = [sizeCollection;temp];
            numClusters = numClusters-1;
        end
        sortedSize = sortrows(sizeCollection,1);
        out = sortedSize(end,2);
        
        pointsTemp = ptCloud_temp.Location(find(labels==out(1)),:);
        points = moveToOrigin(pointsTemp);
        
        
        
        PCA_ref =  pca(points);
        angle = atand(PCA_ref(1,1)/PCA_ref(2,1));
        points = AxelRot(points', angle, [0 0 1],[])';
        ptCloud_temp2 = pointCloud(moveToOrigin(points));
end

