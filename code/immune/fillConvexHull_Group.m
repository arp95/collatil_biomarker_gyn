function [totalArea,avgArea,medianArea,stdArea,modeArea]=fillConvexHull_Group(members,nodes,ccc)
numMembers=length(members);
areas=[];
for i = 1:numMembers
    member = members{i};
    col = nodes.centroid_c(member)';
    row = nodes.centroid_r(member)';
    
    if length(col) >  2
        [k,a] = convhull(col,row);
        plot(col(k),row(k),'color',ccc, 'LineWidth',4);
        fill(col(k),row(k),ccc,'facealpha',.5)
        areas=[areas;a];
    end
end
totalArea=sum(areas);
avgArea=mean(areas);
medianArea=median(areas);
stdArea=std(areas);
modeArea=mode(areas);

end

