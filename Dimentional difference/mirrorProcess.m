function [newPointCloud,labels] = mirrorProcess(leftPointCloud_original)
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
        upper_points_size = size(points((points(:,3)>0),:));
        lower_points_size = size(points((points(:,3)<0),:));
        if(upper_points_size(1)>lower_points_size(1))
            points = cat(2,points(:,1:2),-points(:,3));
            disp('wrong z direction')
            [angleZ,rotationAxis,distance] = mirrorToGroundKinect(ptCloud);
            ptCloud = pointCloud([points(:,1:2),points(:,3) - distance]);
        end
        
        DISTANCE = 88;
        footLabels = find(((ptCloud.Location(:,3)>1)&(ptCloud.Location(:,3)<90))|((ptCloud.Location(:,3)<-DISTANCE-1)&(ptCloud.Location(:,3)>-DISTANCE-15))); 
        ptCloud_temp = pointCloud(ptCloud.Location(footLabels,:));

                       
        [labels,numClusters] = pcsegdist(pointCloud(ptCloud_temp.Location),5);        
        sizeCollection = [];
        while(numClusters>0)
            group = ptCloud_temp.Location(find(labels==numClusters),:);
            temp = [size(group,1),numClusters];
            sizeCollection = [sizeCollection;temp];
            numClusters = numClusters-1;
        end
        sortedSize = sortrows(sizeCollection,1);
        out = sortedSize([end-1:end],2);
        
        top = ptCloud_temp.Location(find(labels==out(2)),:);
        buttom = ptCloud_temp.Location(find(labels==out(1)),:);
        
        temp = [buttom(:,1:2),-(buttom(:,3)+DISTANCE)];
        ptCloudButtom = pcdenoise(pointCloud(temp));
        points = [top;ptCloudButtom.Location];
        
        PCA_ref =  pca(points);
        angle = atand(PCA_ref(1,1)/PCA_ref(2,1));
        points = AxelRot(points', angle, [0 0 1],[])';
        newPointCloud = pointCloud(moveToOrigin(points));
       
        
        topSize = size(top);
        buttomSize = size(ptCloudButtom.Location);
        
        labels = [zeros(1,topSize(1))';ones(1,buttomSize(1))'];
        
        pcshow(newPointCloud);
end

