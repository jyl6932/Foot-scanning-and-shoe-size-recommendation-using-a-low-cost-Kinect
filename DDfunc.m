function [dimen_difference] = DDfunc(points_grid_foot,points_grid_shoe,footFileName,shoeSize)
%% Points cloud :
saveComparisonPath = 'F:\A_Jin Yiling\Trail\ShoeFootEXP0922_Final\ShoeFootComparison_2';
%原来的图
%分割成三段分别排序
[footSorted] = orderOutline(points_grid_foot);

figureOutfit = figure('NumberTitle','off','Name','Outfit Comparison');hold on; axis equal;
plot(footSorted(:,1),footSorted(:,2),'b+-','MarkerSize',2);
plot(points_grid_shoe(:,1),points_grid_shoe(:,2),'ko','MarkerSize',2);
%plot(points_move_back(:,1),points_move_back(:,2),'ro','MarkerSize',3);

% dimentional difference
[closestPoints,dimen_difference] = Dimensional_difference(footSorted(:,1:2),points_grid_shoe(:,1:2));
savePath = saveComparisonPath;
fileName = [footFileName,'_',shoeSize];
saveFile(figureOutfit,savePath,fileName);
close(figureOutfit);
end

