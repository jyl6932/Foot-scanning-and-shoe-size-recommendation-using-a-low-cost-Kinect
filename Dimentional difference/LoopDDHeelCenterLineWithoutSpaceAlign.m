clc;clear;
saveFeaturesPath = 'F:\A_Jin Yiling\pilot test\Results\ExScanHeelCenterLine.xlsx';
saveGraphyPath = 'F:\A_Jin Yiling\pilot test\Results\FootGraphy';
footPath =  'F:\A_Jin Yiling\pilot test\Model\Expriment Input'; 

%% Read all the .obj files under the foot model folder.
% Get a list of all files in the folder with the desired file name pattern.
featureTable = {'Foot Number','Length','Width',...
           '40mm Width','MidFoot Width','MidFoot Hight',...
                'Instep Girth','Short Heel Girth','Long Heel Girth','Ankle Girth'};
        
theFiles = dir(footPath);
for k = 1 : length(theFiles)
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(theFiles(k).folder, baseFileName);
    fullFileName = fullfile(fullFileName, 'plantform');
    fprintf(1, 'Now reading %s\n', fullFileName);
    try 
        % Load the file Both sides of foots ( and reference )
        leftPointCloud_original = pcread(fullfile(fullFileName,'scan.ply'));
       
        %left_referencePC = pcread(fullfile(fullFileName,'left_reference.ply'));
        FileNameLeft = [baseFileName,'plantform'];

        
        [ptCloudLeft] = spaceAlign(leftPointCloud_original);

       %% Check the direction of the foot
        ptCloudLeft = AlignmentDir(ptCloudLeft);
       

       % leftPtAligned = AlignmentBrannock(leftPointCloud_align);
       % RightPtAligned = AlignmentBrannock(rightPointCloud_align);
        [leftPtAligned] = AlignmentSecond(ptCloudLeft);
        
        [featuresLeft] = FeatureExtractionFullButtom(leftPtAligned,FileNameLeft);
        
        featureTable = cat(1,featureTable,featuresLeft);
        
        %{
        rightPointCloud_original = pcread(fullfile(fullFileName,'right.ply'));
        %right_referencePC = pcread(fullfile(fullFileName,'right_reference.ply'));
        FileNameRight = [baseFileName,'right'];
        [ptCloudRight] = spaceAlign(rightPointCloud_original);
        ptCloudRight = AlignmentDir(ptCloudRight);
        [RightPtAligned] = AlignmentSecond(ptCloudRight);
        [featuresRight] = FeatureExtractionFullButtom(RightPtAligned,FileNameRight);
        featureTable = cat(1,featureTable,featuresRight);
        %}
        points = leftPtAligned.Location;
        footLabels = find((points(:,3)<90)); 
        ptCloud_temp = pointCloud(points(footLabels,:));
        pcwrite(ptCloud_temp,FileNameLeft,'Encoding','ascii');
    %}    
    catch
        disp('Could not read the file \n');
    end
        
end


 %% Save the xlsx file
 footFileName = 'length_width';
 writecell(featureTable,saveFeaturesPath,'Sheet',footFileName);
     