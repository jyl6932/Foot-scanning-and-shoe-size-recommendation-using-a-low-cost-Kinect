function [outputArg1,outputArg2] = func(inputArg1,inputArg2)
%UNTITLED3 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
outputArg1 = 1/(sqrt(1+(inputArg2/inputArg1)^2));
outputArg2 = inputArg2/inputArg1*outputArg1 ;
return 

