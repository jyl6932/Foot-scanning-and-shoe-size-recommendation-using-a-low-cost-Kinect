function [ptCloud_rotated] = AlignZaxis_noreference(data_ref,data_obj)
%Finish alignment along the z-axis 
%   此处显示详细说明
%% PCA the reference model to find the rotation matrix (align the Z)
PCA_ref = pca(data_ref);
e1_ref = PCA_ref(:,1)'; e2_ref = PCA_ref(:,2)'; e3_ref = PCA_ref(:,3)';
RotationMatrix_ref = [e1_ref;e2_ref;e3_ref];
data_rotated = (RotationMatrix_ref*data_obj')';
[data_rotated] = NormalPC(data_rotated);


%% Rotated if the direction is wrong, along the y-axis
ptCloud = pointCloud(data_rotated);
if (ptCloud.ZLimits(2)>ptCloud.XLimits(2))
    R = [0 0 -1; 0 1 0; 1 0 0];
    data_rotated = (R*data_rotated')';
    [data_rotated] = NormalPC(data_rotated);
    ptCloud_rotated = pointCloud(data_rotated);
    disp('wrong rotation direction')
    
else
    ptCloud_rotated = pointCloud(data_rotated);
end


%% Check if the model is in the right direction
upper_z_points =  ptCloud_rotated.Location(find(ptCloud_rotated.Location(:,3)>ptCloud_rotated.ZLimits(2)*0.5));
lower_z_points =  ptCloud_rotated.Location(find(ptCloud_rotated.Location(:,3)<ptCloud_rotated.ZLimits(2)*0.5));

upper_size = size(upper_z_points);
lower_size = size(lower_z_points);

if ( upper_size(1) > lower_size(1))
    data_rotated = cat(2,data_rotated(:,1:2),-data_rotated(:,3));
    [data_rotated] = NormalPC(data_rotated);
    disp('wrong z direction')
    ptCloud_rotated = pointCloud(data_rotated);
else
    ptCloud_rotated = pointCloud(data_rotated);
end
%% Check if the model is in the right direction
XLength =  ptCloud_rotated.XLimits(2) - ptCloud_rotated.XLimits(1);
YLength =  ptCloud_rotated.YLimits(2) - ptCloud_rotated.YLimits(1);

if ( YLength> XLength)
    R = [0 1 0; 1 0 0; 0 0 1];
    data_rotated = (R*data_rotated')';
    [data_rotated] = NormalPC(data_rotated);
    ptCloud_rotated = pointCloud(data_rotated);
    disp('wrong xy direction')
else
    ptCloud_rotated = pointCloud(data_rotated);
end
end
