clc;clear;
saveFeaturesPath = 'F:\A_Jin Yiling\pilot test\Results\GroundWithMarkers.xlsx';
saveGraphyPath = 'F:\A_Jin Yiling\pilot test\Results\FootGraphy';
footPath =  'F:\A_Jin Yiling\pilot test\Model\Input\Ground\ExScan';  
referencePath = 'F:\A_Jin Yiling\pilot test\Model\Input\Reference\';  
%% Read all the .obj files under the foot model folder.
% Get a list of all files in the folder with the desired file name pattern.
%% Read all the .obj files under the foot model folder.
% Get a list of all files in the folder with the desired file name pattern.
featureTable = {'Foot Number','Length','Arch Length','Heel to Medial','Heel to Lateral','Width','Bimalleolar Width','MidFoot Width','40mm Width',...
                'Medial Height','Lateral Height','MidFoot Hight',...
                'Instep Girth','Short Heel Girth','Long Heel Girth','Ankle Girth','Ball Girth'};
theFiles = dir(footPath);
for k = 1 : length(theFiles)
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(theFiles(k).folder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
    try 
        % Load the file Both sides of foots ( and reference )
        leftPointCloud_original = pcread(fullfile(fullFileName,'left.ply'));
        rightPointCloud_original = pcread(fullfile(fullFileName,'right.ply'));

        FileNameLeft = [baseFileName,'left'];
        FileNameRight = [baseFileName,'right'];
       
        [ptCloudLeft] = groundPreprocessing(leftPointCloud_original);
        [ptCloudRight] = groundPreprocessing(rightPointCloud_original);
       %% Check the direction of the foot
        leftPointCloud_align = AlignmentDir(ptCloudLeft);
        rightPointCloud_align = AlignmentDir(ptCloudRight);
        
        leftPointCloud_align.Color = ptCloudLeft.Color;
        rightPointCloud_align.Color = ptCloudRight.Color;
        
        leftPtAligned = AlignmentBrannock(leftPointCloud_align);
        RightPtAligned = AlignmentBrannock(rightPointCloud_align);
        %[leftPtAligned] = AlignmentSecond(leftPointCloud_align);
        %[RightPtAligned] = AlignmentSecond(rightPointCloud_align)
        leftPtAligned.Color = ptCloudLeft.Color;
        RightPtAligned.Color = ptCloudRight.Color;

        figure(3000);hold on;
        pcshow(leftPtAligned);
        pcshow(RightPtAligned);

        [featuresLeft] = FeatureExtraction(leftPtAligned,FileNameLeft);
        [featuresRight] = FeatureExtraction(RightPtAligned,FileNameRight);
        
        featureTable = cat(1,featureTable,featuresLeft);
        featureTable = cat(1,featureTable,featuresRight);
    %}    
    catch
        disp('Could not read the file \n');
    end
        
end


