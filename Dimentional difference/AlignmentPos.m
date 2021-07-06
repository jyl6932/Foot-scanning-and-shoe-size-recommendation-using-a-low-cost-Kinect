function [ptCloud] = AlignmentPos(modelPC,referencePC)
%Alignment the object or foot
    %% Do the alignment along the z-axis (PCA)
     ptCloud = AlignmentReferencePCA(double(referencePC.Location),double(modelPC.Location));
    
    %% Check the direction of the foot
    ptCloud = AlignmentDir(ptCloud);
    
    %% Do the briefly alignment along the xy-plane (PCA) ���������̫�ȶ�����ʱ����ɱ�ƽ������Ŀǰ���Ҳ���ԭ�򡣵���������ķ��������Ͽ��Զ����
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

