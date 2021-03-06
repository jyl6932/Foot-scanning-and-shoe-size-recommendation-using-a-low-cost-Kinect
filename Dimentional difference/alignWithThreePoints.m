clc;clear;
footPath =  'F:\A_Jin Yiling\pilot test\Model\Input\Foot';  
referencePath = 'F:\A_Jin Yiling\pilot test\Model\Input\Reference\'; 
theFiles = dir(footPath);
for k = 1 : length(theFiles)
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(theFiles(k).folder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
    try 
        % Load the file Both sides of foots ( and reference )
        leftPointCloud_original = pcread(fullfile(fullFileName,'left.ply'));
        left_referencePC = pcread(fullfile(fullFileName,'left_reference.ply'));

        FileNameLeft = [baseFileName,'left'];
        FileNameRight = [baseFileName,'right'];
        
        % 有reference alignment 需要加这一步
        [leftPointCloud] = AlignmentPos(leftPointCloud_original,left_referencePC);
        
        % Using heel centerline to align the foot
        ptCloud = AlignmentBrif(leftPointCloud);
        ptCloud.Color = leftPointCloud_original.Color;
        
        figure(6000);hold on;
        pcshow(ptCloud);
        
        %% Extract potential landmark id based on color image
        [angleZ,rotationAxis,distance] = rotatedAngle(ptCloud);
        
        while(angleZ>0.01)
            points = ptCloud.Location;
            points = AxelRot(points', angleZ, rotationAxis,[])';
            ptCloud = pointCloud([points(:,1:2),points(:,3) - distance]);
            ptCloud.Color = leftPointCloud_original.Color;
            [angleZ,rotationAxis] = rotatedAngle(ptCloud);
        end
        ptCloud = pointCloud(moveToOrigin(ptCloud.Location));
        ptCloud.Color = leftPointCloud_original.Color;
        pcshow(ptCloud);
        
        
        
    catch
        disp('Could not read the file \n');
    end
        
end



