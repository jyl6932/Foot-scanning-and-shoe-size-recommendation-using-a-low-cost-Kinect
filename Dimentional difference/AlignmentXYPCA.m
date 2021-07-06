function [ptCloud_rotated] = AlignmentXYPCA(OriginalPoints)
%UNTITLED5 此处显示有关此函数的摘要
%   此处显示详细说明
PCA = pca(OriginalPoints);
e1 = PCA(:,1)'; e3 = PCA(:,2)'; e2 = PCA(:,3)';
n3 = [0 0 1];
% sclar the vector into xy plane and normalize the vector
[e1_1_aft,e1_2_aft] = func(e1(1),e1(2));
[e3_1_aft,e3_2_aft] = func(e3(1),e3(2));
e1_aft = [ e1_1_aft e1_2_aft 0];
e3_aft = [ e3_1_aft e3_2_aft 0];

R = [e1_aft;e3_aft;n3];
data = (R*OriginalPoints')';
%[data] = NormalPC(data);
ptCloud_rotated = pointCloud(data);

end