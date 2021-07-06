clc;clear;
saveFeaturesPath = 'F:\A_Jin Yiling\Trail\ShoeFootEXP0922_Final\Features_20_HeelAlign_Arch.xlsx';
saveGraphyPath = 'F:\A_Jin Yiling\Trail\ShoeFootEXP0922_Final\1011\FootGraphy';
footPath =  'F:\A_Jin Yiling\Trail\ShoeFootEXP0922_Final\Scan\Foot';  
%referencePath = 'F:\A_Jin Yiling\ScannerData\Processed_LabScanner0917\Reference\';  
%% Read all the .obj files under the foot model folder.
% Get a list of all files in the folder with the desired file name pattern.

featureTable = {'Foot Number','Left Length','Left Width','Left Width Dis','Right Length','Right Width','Arch Width'};

theFiles = dir(footPath);
for k = 1 : length(theFiles)
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(theFiles(k).folder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
    try 
        % Load the file Both sides of foots ( and reference )
        leftPointCloud = pcread(fullfile(fullFileName,'left.ply'));
        rightPointCloud = pcread(fullfile(fullFileName,'right.ply'));
        FileNameLeft = [baseFileName,'left'];
        FileNameRight = [baseFileName,'right'];
        
        % Only consider the bottom part of the foot (25mm)
        ptCloud_bottom_foot_left = leftPointCloud.Location(find(leftPointCloud.Location(:,3)<25),:);
        ptCloud_bottom_foot_right = rightPointCloud.Location(find(rightPointCloud.Location(:,3)<25),:);
        
        % Using heel centerline to align the foot
        ptCloud_bottom_foot_left = AlignmentBrif(ptCloud_bottom_foot_left);
        ptCloud_bottom_foot_right = AlignmentBrif(ptCloud_bottom_foot_right);
        
        % Check the direction of the foot
        leftPointCloud = AlignmentDir(ptCloud_bottom_foot_left);
        rightPointCloud = AlignmentDir(ptCloud_bottom_foot_right);
   
        % Alignment use heel center line
        pointsLeft = AlignmentSecond(leftPointCloud);
        pointsRight = AlignmentSecond(rightPointCloud);
        
        % Extract features from the foot model
        [featuresLeft] = FeatureExtraction(pointsLeft,FileNameLeft);
        [featuresRight] = FeatureExtraction(pointsRight,FileNameRight);
    
        features = cat(2,baseFileName,featuresLeft,featuresRight);
        featureTable = cat(1,featureTable,features);
        
    catch
        fprintf('Could not read the file \n');
    end

end


 %% Save the xlsx file
 footFileName = 'length_width';
 writecell(featureTable,saveFeaturesPath,'Sheet',footFileName);
     