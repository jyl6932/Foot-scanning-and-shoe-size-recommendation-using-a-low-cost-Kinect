%求三角形法向量
function [x,y,z]=fa_vector(p1,p2,p3)
%两个边向量
a=p2-p1;
b=p3-p1;
%求法向量
c=cross(b,a);
%归一化
 norm = sqrt(c(1,1)^2+c(1,2)^2+c(1,3)^2);
 x=c(1,1)/norm;
 y=c(1,2)/norm;
 z=c(1,3)/norm;
end