clc;clear;
saveFeaturesPath = 'F:\A_Jin Yiling\pilot test\Results\withoutAling-plastic.xlsx';
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
        points_left = pcread(fullfile(fullFileName,'scan.ply'));
        
        FileNameLeft = [baseFileName,'plantform'];
       
        %left is 1.4
        %left original is 33
        points_left = pointCloud(AxelRot(points_left.Location', -2 , [0 0 1],[])');
        points_left = AlignmentDir(points_left);
        [featuresLeft] = FeatureExtractionFullButtom(points_left,FileNameLeft);
        featureTable = cat(1,featureTable,featuresLeft);
        
        %{
        points_right = pcread(fullfile(fullFileName,'right.ply'));
        FileNameRight = [baseFileName,'right'];
        points_right = pointCloud(AxelRot(points_right.Location',34.4, [0 0 1],[])');
        points_right = AlignmentDir(points_right);
        [featuresRight] = FeatureExtractionFullButtom(points_right,FileNameRight);
        featureTable = cat(1,featureTable,featuresRight);   
        %}
       
        
        
    %}    
    catch
        disp('Could not read the file \n');
    end
        
end


 %% Save the xlsx file
 footFileName = 'length_width';
 writecell(featureTable,saveFeaturesPath,'Sheet',footFileName);
     