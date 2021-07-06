function [ptCloud] = AlignmentNoreference(ptCloud)
%Alignment the object or foot
    %% Do the briefly alignment along the xy-plane (PCA)
    ptCloud = AlignXY0909(ptCloud.Location);
    
    %% Touch the ground
    [ptCloud] = CheckYdirection(ptCloud.Location);
    ptCloud = TouchTheGround_forward(ptCloud.Location);
    ptCloud = TouchTheGround(ptCloud.Location);

end

