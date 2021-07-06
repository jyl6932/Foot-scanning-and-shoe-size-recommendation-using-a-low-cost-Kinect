clc;clear;
saveFeaturesPath = 'F:\A_Jin Yiling\pilot test\Results\GroundWithouLandmarksKinect.xlsx';
saveGraphyPath = 'F:\A_Jin Yiling\pilot test\Results\FootGraphy';
footPath =  'F:\A_Jin Yiling\pilot test\Model\Input\MirrorGround';  
%footPath =  'F:\A_Jin Yiling\pilot test\Model\Input\GroundFinal\ExScanWater';
%% Read all the .obj files under the foot model folder.
% Get a list of all files in the folder with the desired file name pattern.
%% Read all the .obj files under the foot model folder.
% Get a list of all files in the folder with the desired file name pattern.
featureTable = {'Foot Number','Length','Width',...
           '40mm Width','MidFoot Width','MidFoot Hight',...
                'Instep Girth','Short Heel Girth','Long Heel Girth','Ankle Girth'};
theFiles = dir(footPath);
for k = 1 : length(theFiles)
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(theFiles(k).folder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
    try 
        % Load the file Both sides of foots ( and reference )
        %leftPointCloud_original = pcread(fullfile(fullFileName,'left.ply'));
        rightPointCloud_original = pcread(fullfile(fullFileName,'Mirror.ply'));

        %FileNameLeft = [baseFileName,'left'];
        FileNameRight = [baseFileName,'right'];
       
        %[ptCloudLeft] = groundPreprocessing(leftPointCloud_original);
        [ptCloudRight,labels] = mirrorProcess(rightPointCloud_original);
        rightPointCloud_align = AlignmentDir(ptCloudRight);
              
        
        
        
        [RightPtAligned] = AlignmentSecond(rightPointCloud_align)
        figure(3000);hold on;
        %pcshow(leftPtAligned);
        pcshow(RightPtAligned);

        %[featuresLeft] = FeatureExtractionWithoutLandmarks(leftPtAligned,FileNameLeft);
        [featuresRight] = FeatureExtractionWithoutLandmarksGround(RightPtAligned,labels,FileNameRight);
        
        %featureTable = cat(1,featureTable,featuresLeft);
        featureTable = cat(1,featureTable,featuresRight);
       
    catch
        disp('Could not read the file \n');
    end
        
end


