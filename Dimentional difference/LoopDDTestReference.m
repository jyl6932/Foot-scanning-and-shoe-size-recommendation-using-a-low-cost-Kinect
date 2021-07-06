clc;clear;
saveFeaturesPath = 'F:\A_Jin Yiling\pilot test\Results\Features_20_HeelAlign_Arch.xlsx';
saveGraphyPath = 'F:\A_Jin Yiling\pilot test\Results\FootGraphy';
footPath =  'F:\A_Jin Yiling\pilot test\Model\Input\PlasticDangling';  
referencePath = 'F:\A_Jin Yiling\pilot test\Model\Input\Reference\';  
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
        left_referencePC = pcread(fullfile(fullFileName,'left_reference.ply'));
        right_referencePC = pcread(fullfile(fullFileName,'right_reference.ply'));

        FileNameLeft = [baseFileName,'left'];
        FileNameRight = [baseFileName,'right'];
        
        % 有reference alignment 需要加这一步
        [leftPointCloud_align] = AlignmentPos(leftPointCloud_original,left_referencePC);
        [rightPointCloud_align] = AlignmentPos(rightPointCloud_original,right_referencePC);
        
        % Using heel centerline to align the foot
         % leftPointCloud_align = AlignmentBrif(leftPointCloud);
        %  rightPointCloud_align = AlignmentBrif(rightPointCloud);
        
        % Check the direction of the foot
        %leftPointCloud = AlignmentDir(leftPointCloud_align);
        %rightPointCloud = AlignmentDir(rightPointCloud_align);
        
        % Extract features from the foot model
        leftPointCloud_align.Color = leftPointCloud_original.Color;
        rightPointCloud_align.Color = rightPointCloud_original.Color;
        
        leftPtAligned = AlignmentBrannock(leftPointCloud_align);
        RightPtAligned = AlignmentBrannock(rightPointCloud_align);
        %[leftPtAligned] = AlignmentSecond(leftPointCloud_align);
        %[RightPtAligned] = AlignmentSecond(rightPointCloud_align)
        leftPtAligned.Color = leftPointCloud_original.Color;
        RightPtAligned.Color = rightPointCloud_original.Color;

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


 %% Save the xlsx file
 footFileName = 'length_width';
 writecell(featureTable,saveFeaturesPath,'Sheet',footFileName);
     