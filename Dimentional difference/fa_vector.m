%�������η�����
function [x,y,z]=fa_vector(p1,p2,p3)
%����������
a=p2-p1;
b=p3-p1;
%������
c=cross(b,a);
%��һ��
 norm = sqrt(c(1,1)^2+c(1,2)^2+c(1,3)^2);
 x=c(1,1)/norm;
 y=c(1,2)/norm;
 z=c(1,3)/norm;
end