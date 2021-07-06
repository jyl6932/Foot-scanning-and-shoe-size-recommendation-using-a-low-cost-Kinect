function [ptCloud] = AlignmentPos(modelPC,referencePC)
%Alignment the object or foot
    %% Do the alignment along the z-axis (PCA)
     ptCloud = AlignmentReferencePCA(double(referencePC.Location),double(modelPC.Location));
    
    %% Check the direction of the foot
    ptCloud = AlignmentDir(ptCloud);
    
    %% Do the briefly alignment along the xy-plane (PCA) 这个方法不太稳定，有时候会变成扁平，但是目前还找不出原因。但是用下面的方法大体上可以对齐脚
    %ptCloud = AlignmentXYPCA(ptCloud.Location);
    
    %% Touch the ground
    %points(:,3) = -points(:,3) + max(points(:,3));

    [ptCloud,angle] = TouchTheGround_forward(ptCloud.Location);
     while(angle>0.01)
        [ptCloud,angle] = TouchTheGround(ptCloud.Location);
    end
    [ptCloud,angle] = TouchTheGround(ptCloud.Location);
    while(angle>0.01)
        [ptCloud,angle] = TouchTheGround(ptCloud.Location);
    end
    
    ptCloud = AlignmentDir(ptCloud);
end

