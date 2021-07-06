function [ptCloud] = Alignment(modelPC,referencePC)
%Alignment the object or foot
    %% Do the alignment along the z-axis (PCA)
     ptCloud = AlignZaxis_noreference(double(referencePC.Location),double(modelPC.Location));

    %% Do the briefly alignment along the xy-plane (PCA)
    ptCloud = AlignXY0909(ptCloud.Location);
    
    %% Touch the ground
    [ptCloud] = CheckYdirection(ptCloud.Location);
    ptCloud = TouchTheGround_forward(ptCloud.Location);
    ptCloud = TouchTheGround(ptCloud.Location);

end

