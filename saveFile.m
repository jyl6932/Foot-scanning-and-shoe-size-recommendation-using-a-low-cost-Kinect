function saveFile(imageFrame,savePath,fileName)
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
savePathRoad = [savePath,'\',fileName,'.jpg'];
saveas(imageFrame,savePathRoad);
disp("Save the "+fileName+'!!!');
end

