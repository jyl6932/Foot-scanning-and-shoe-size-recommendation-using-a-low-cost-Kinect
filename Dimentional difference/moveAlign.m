function [points] = moveAlign(points,heel_point);
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
points(:,1) = points(:,1) - min(points(:,1));

points(:,2) = points(:,2) - heel_point(2);


end

