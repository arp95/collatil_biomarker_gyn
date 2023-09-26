function drawGraph_standard( coords,M,colors,lineWidth,markerSize,transpLine,transpMarker )
%DRAWGRAPH Summary of this function goes here
%   Detailed explanation goes here
if nargin<5
    lineWidth=3;
end

if nargin<6
    markerSize=20;
end

if nargin<76
    transpLine=1;
end

if nargin<8
    transpMarker=.8;
end






numGroups=length(coords);

for k=1:numGroups
    matrix=M{k};
    if ~isempty(matrix)
    centroids=coords{k};
    numCent=length(centroids);
    for i=1:numCent
        for j=1+i:numCent
            if matrix(i,j)>0
                s=plot([centroids(i,1),centroids(j,1)],[centroids(i,2),centroids(j,2)],'color',colors{k},'LineWidth',lineWidth);
                s.Color(4)=transpLine;
                plot([centroids(i,1),centroids(j,1)],[centroids(i,2),centroids(j,2)],'k','LineWidth',1);
            end
        end
    end
    
    if markerSize>0
        
        scatter1 = scatter(centroids(:,1),centroids(:,2),markerSize,'MarkerFaceColor',colors{k},'MarkerEdgeColor','k');
        alpha(scatter1,transpMarker);
    end
    
end

end
end