function [data_normal] = NormalPC(OriginalPoints)
%UNTITLED4 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
data_normal = OriginalPoints;
OriniginalPC = pointCloud(OriginalPoints);
data_normal(:,1) = OriniginalPC.Location(:,1)-OriniginalPC.XLimits(1);
data_normal(:,2) = OriniginalPC.Location(:,2)-OriniginalPC.YLimits(1);
%data_normal(:,3) = OriniginalPC.Location(:,3)-OriniginalPC.ZLimits(1);
end

