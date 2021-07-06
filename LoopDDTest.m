clc;clear;
saveComparisonPath = 'F:\A_Jin Yiling\Trail\ShoeFootEXP0922_Final\ShoeFootComparison_full';
saveDDPath = 'F:\A_Jin Yiling\Trail\ShoeFootEXP0922_Final\DD_full';
saveFeaturePath = 'F:\A_Jin Yiling\Trail\ShoeFootEXP0922_Final\Features_toe_subjects.xlsx';
saveFeatureHalfPath = 'F:\A_Jin Yiling\Trail\ShoeFootEXP0922_Final\HalfFeatures_toe_subject.xlsx';
shoeFolderPath = 'F:\A_Jin Yiling\Trail\ShoeFootEXP0922_Final\Scan\Shoe\';
footFolderPath = 'F:\A_Jin Yiling\Trail\ShoeFootEXP0922_Final\Scan\Foot';  
 %% Read all the .obj files under the shoe model folder.
 File = dir(fullfile(shoeFolderPath,'*.ply'));  % 显示文件夹下所有符合后缀名为.txt文件的完整信息
 shoeFileNames = {File.name}';            % 提取符合后缀名为.txt的所有文件的文件名，转换为n行1列
 ShoeLength_Names = size(shoeFileNames,1);    % 获取所提取数据文件的个数
 
 
 % Get a list of all files in the folder with the desired file name pattern.
theFiles = dir(footFolderPath);
for k = 1 : length(theFiles)
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(theFiles(k).folder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
    try    
       
        leftPointCloud = pcread(fullfile(fullFileName,'left.ply'));
        %rightPointCloud = pcread(fullfile(fullFileName,'right.ply'));
            
        FileNameLeft = [baseFileName,'left'];
        %FileNameRight = [baseFileName,'right'];
        
       %% Alignmet the foot 
        ptCloud_bottom_foot = leftPointCloud.Location(find(leftPointCloud.Location(:,3)<20),:);
        [ptCloud_bottom_foot] = AlignmentBrif(ptCloud_bottom_foot);
        [areaOfPolygon_foot,areaInsideSplineCurve_foot,splineXY_foot] = pchipBoundary(ptCloud_bottom_foot);
        [points_grid_foot] = AlignmentSecond(splineXY_foot');
        [points_grid_foot] = AlignmentBrif(points_grid_foot);

        figure(3);hold on; grid on;axis equal;
        plot(points_grid_foot(:,1),points_grid_foot(:,2),'*r','MarkerSize',5);


        %% Draw
        figureDD = figure('NumberTitle','off','Name','Dimentional Difference');hold on; axis equal;
        fontSize=10;
        title('Dimensional Difference', 'FontSize', fontSize);
        xlabel('Percentage of Perimeter', 'FontSize', fontSize);
        ylabel('Dimensional Difference(mm)', 'FontSize', fontSize);

    
    
        figureDDHalf = figure('NumberTitle','off','Name','Dimentional Difference');hold on; axis equal;
        fontSize=10;
        title('Dimensional Difference', 'FontSize', fontSize);
        xlabel('Percentage of Perimeter', 'FontSize', fontSize);
        ylabel('Dimensional Difference(mm)', 'FontSize', fontSize);  


        outfit = figure('NumberTitle','off','Name','Outfit');hold on; axis equal;
       
        %% 读取shoe的数据循环
        FileNames = [];
        features = {'Size','Absolute Mean','Tight Duration','Loss Duration','Mean Tightness','Mean Looseness','|DD|>5','areaOffoot/shoe'};

        featuresHalf ={'Size','Absolute Mean','Tight Duration','Loss Duration','Mean Tightness','Mean Looseness','|DD|>5','areaOffoot/shoe'};
  
        for shoeRow = 1 : ShoeLength_Names
             % Extact the point cloud data from the file
             shoeName = shoeFileNames(shoeRow,1);
             ShoeFilePath = strcat(shoeFolderPath ,shoeName);
             ptCloud_shoe = pcread(ShoeFilePath{1});

            %% Alignmet the shoe
            points = ptCloud_shoe.Location;
            points(:,1) = -points(:,1);points(:,2) = -points(:,2); ptCloud_shoe = pointCloud(points);
            bottom_shoe = points(find(points(:,3)<20),:); SHOE = bottom_shoe(:,1:2);[SHOE] = moveToOrigin(SHOE);
            %[areaOfPolygon_shoe,areaInsideSplineCurve_shoe,splineXY_shoe] = pchipBoundary(ptCloud_bottom_shoe);
            bottom_shoe = bottom_shoe(find(bottom_shoe(:,3)<20),:);
            %[ptCloud_bottom_foot] = AlignmentBrif(bottom_shoe);
             [bottom_shoe] = moveToOrigin(bottom_shoe);
            [areaOfPolygon_shoe,areaInsideSplineCurve_foot,splineXY_foot] = pchipBoundary(bottom_shoe);
            [points_grid_shoe] = AlignmentSecond(splineXY_foot');
            [points_grid_shoe] = AlignmentBrif(points_grid_shoe);

             figure(outfit);
             hold on;axis equal;axis equal;
             scatter(points_grid_shoe(:,1),points_grid_shoe(:,2)),'+r';
             %plot(points_grid_foot(:,1),points_grid_foot(:,2));
             


         
           %% 特征提取
            shoeName = extractBefore(shoeName,'.');
            FileNames = [FileNames,shoeName];
            shoeFileName = [shoeName{1},'_DD'];
            footFileName = baseFileName;
            [dimen_difference] = DDfunc(points_grid_foot,points_grid_shoe,footFileName,shoeFileName);
            colOrder = ['y','m','c','r','g','b','k','w'];
            x =[];y=[];
            for slice = 1:length(dimen_difference)-1
                x = [x;slice/length(dimen_difference)*100];
                y = [y,dimen_difference(slice,3)];
            end

            figure(figureDD); hold on
            plot(x,y,'LineWidth', 2, 'Color', colOrder(shoeRow));
            hold off;

            %% Calculate the features
            tightDuration = length(dimen_difference(find(dimen_difference(:,3)<0),:))/length(dimen_difference);
            lossDuration = length(dimen_difference(find(dimen_difference(:,3)>=0)))/length(dimen_difference);
            meanTightness = mean(dimen_difference(find(dimen_difference(:,3)<0),3));
            meanLooseness = mean(dimen_difference(find(dimen_difference(:,3)>=0),3));
            fiveDuration = length(dimen_difference(find(abs(dimen_difference(:,3))>=5),:))/length(dimen_difference);
            areOfShoeFoot = areaOfPolygon_foot/areaOfPolygon_shoe;

            temp = {shoeName{1},mean(abs(dimen_difference(:,3))),tightDuration,lossDuration,meanTightness,meanLooseness,fiveDuration,areOfShoeFoot};
            features = cat(1,features,temp);

        
        
          %% 去掉fore-foot
            footLength = max(points_grid_foot(:,1));
            points_grid_foot_half = points_grid_foot(find(points_grid_foot(:,1)<footLength*0.73),:);
            points_grid_shoe_half = points_grid_shoe(find(points_grid_shoe(:,1)<footLength*0.73),:);

            % 特征提取
             shoeFileName = [shoeName{1},'_withoutToe_DD'];
             footFileName = baseFileName;
             [dimen_difference] = DDfunc(points_grid_foot_half,points_grid_shoe_half,footFileName,shoeFileName);
             colOrder = ['y','m','c','r','g','b','k','w'];
             x =[];y=[];
             for slice = 1:length(dimen_difference)-1
                    x = [x;slice/length(dimen_difference)*100];
                    y = [y,dimen_difference(slice,3)];
             end

             figure(figureDDHalf); hold on
             plot(x,y,'LineWidth', 2, 'Color', colOrder(shoeRow));
             hold off;

            %% Calculate the features
             tightDuration = length(dimen_difference(find(dimen_difference(:,3)<0),:))/length(dimen_difference);
             lossDuration = length(dimen_difference(find(dimen_difference(:,3)>=0)))/length(dimen_difference);
             meanTightness = mean(dimen_difference(find(dimen_difference(:,3)<0),3));
             meanLooseness = mean(dimen_difference(find(dimen_difference(:,3)>=0),3));
             fiveDuration = length(dimen_difference(find(abs(dimen_difference(:,3))>=5),:))/length(dimen_difference);
              

             temp = {shoeName{1},mean(abs(dimen_difference(:,3))),tightDuration,lossDuration,meanTightness,meanLooseness,fiveDuration,areOfShoeFoot};
             featuresHalf = cat(1,featuresHalf,temp); 
        end

    
    
    grid on;
    legend(FileNames);hold off;
    footFileName = [baseFileName ,'_DD'];
    saveFile(figureDD,saveDDPath,footFileName);
    close(figureDD);
    
    writecell(features,saveFeaturePath,'Sheet',footFileName)
    
    
     grid on;
    legend(FileNames);hold off;
    footFileName = [baseFileName ,'half_DD'];
    saveFile(figureDDHalf,saveDDPath,footFileName);
    close(figureDDHalf);
    
    writecell(featuresHalf,saveFeatureHalfPath,'Sheet',footFileName)


    catch
        fprintf('Could not read the file \n');
    end



end
