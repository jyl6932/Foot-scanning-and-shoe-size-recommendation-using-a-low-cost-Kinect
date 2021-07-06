function [rotatedptCloud] = AlignmentBrannock(ptCloud)
%UNTITLED2 此处显示有关此函数的摘要
[d_M1,rotatedptCloud] = BronnockAlignOneStep(ptCloud);
rotatedptCloud.Color = ptCloud.Color;
while(abs(d_M1)>0.5)
    [d_M1,rotatedptCloud] = BronnockAlignOneStep(rotatedptCloud);
    rotatedptCloud.Color = ptCloud.Color;
end
fprintf('Finish alignment');
end

