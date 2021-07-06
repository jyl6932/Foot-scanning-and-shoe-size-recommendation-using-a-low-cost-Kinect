function [rotatedptCloud] = AlignmentBrannock(ptCloud)
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
[d_M1,rotatedptCloud] = BronnockAlignOneStep(ptCloud);
rotatedptCloud.Color = ptCloud.Color;
while(abs(d_M1)>0.5)
    [d_M1,rotatedptCloud] = BronnockAlignOneStep(rotatedptCloud);
    rotatedptCloud.Color = ptCloud.Color;
end
fprintf('Finish alignment');
end

