function [angleZ,rotationAxis,distance] = mirrorToGround(ptCloud)
%UNTITLED6 此处显示有关此函数的摘要
%   此处显示详细说明
        %% Extract potential landmark id based on color image
        [colorPoints,I] = ColorExtractLandmarkForToGround(ptCloud);
        % Extract potential landmark location information based on color image
        colorPoints = pcdenoise(pointCloud(colorPoints), 'NumNeighbors',100, 'Threshold',0.01);
        
        [labels,numClusters] = pcsegdist(pointCloud(colorPoints.Location),25);
        
        pointA = selectCenterPoint(colorPoints.Location(find(labels==1),:));
        pointB = selectCenterPoint(colorPoints.Location(find(labels==2),:));
        pointC = selectCenterPoint(colorPoints.Location(find(labels==3),:));
        pointD = selectCenterPoint(colorPoints.Location(find(labels==4),:));
                

           
        
        A = (pointA+pointB)/2;
        B = pointC;
        C = pointD;

        [a,b,c,d]=TriPts2Plane(A,B,C);
        plane = [A;B;C;A];
        %{
        plot3(plane(:,1),plane(:,2),plane(:,3),'*');
        hold on
        plot3(plane(:,1),plane(:,2),plane(:,3),'b-');
        grid on;    
        %}
        
        [x,y,z]=fa_vector(A,B,C);
        a = [x,y,z];
        zAxis = [0,0,1];
        
        al = acos(dot(a,zAxis)/(norm(a)*norm(zAxis)));
        angleZ = al/pi*180
       
        rotationAxis = normalize(cross(a,zAxis));
        
        distance = (A(3)+B(3)+C(3))/3;
        
end

