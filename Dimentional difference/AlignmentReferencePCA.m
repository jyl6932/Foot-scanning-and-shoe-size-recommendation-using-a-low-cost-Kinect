function [ptCloud_rotated] = AlignmentReferencePCA(data_ref,data_obj)
%Finish alignment along the z-axis 
%   此处显示详细说明
%% PCA the reference model to find the rotation matrix (align the Z)
PCA_ref = pca(data_ref);
e1_ref = PCA_ref(:,1)'; e2_ref = PCA_ref(:,2)'; e3_ref = PCA_ref(:,3)';
RotationMatrix_ref = [e1_ref;e2_ref;e3_ref];
data_rotated = (RotationMatrix_ref*data_obj')';
[data_rotated] = NormalPC(data_rotated);
ptCloud_rotated = pointCloud(data_rotated);
end
