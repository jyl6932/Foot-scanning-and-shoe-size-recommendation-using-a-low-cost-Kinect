function [outputArg1,outputArg2] = func(inputArg1,inputArg2)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
outputArg1 = 1/(sqrt(1+(inputArg2/inputArg1)^2));
outputArg2 = inputArg2/inputArg1*outputArg1 ;
return 

