function [features,featureNames] = getIntersectionGroups(groups)
%GETGROUPINTERSECTION Summary of this function goes here
%   Detailed explanation goes here

features=[];
featureNames={};

numGroups=length(groups);
comb = combnk(1:numGroups,2);
numComb=size(comb,1);

polygons=struct;

for i=1:numGroups
    col = groups(i).clusterCentroids(:,1);
    row = groups(i).clusterCentroids(:,2);
    
    if length(col)>2
        [ch,a] = convhull(col,row);
        polygons(i).coords=[col(ch) row(ch)];
        polygons(i).area=a;
    else
        polygons(i).coords=[];
        polygons(i).area=0;
    end

    %plot(col(ch),row(ch),'yellow','LineWidth',5);
end

for i=1:numComb
    
    gr1=comb(i,1);
    gr2=comb(i,2);
    
    pol1=polygons(gr1).coords;
    pol2=polygons(gr2).coords;

    if ~isempty(pol1) && ~isempty(pol2)
        polyout = intersect([polyshape(pol1) polyshape(pol2)]);
        int=polyarea(polyout.Vertices(:,1),polyout.Vertices(:,2));

        in1=inpolygon(groups(gr1).clusterCentroids(:,1),...
            groups(gr1).clusterCentroids(:,2),pol2(:,1),pol2(:,2));

        in2=inpolygon(groups(gr2).clusterCentroids(:,1),...
            groups(gr2).clusterCentroids(:,2),pol1(:,1),pol1(:,2));

        avgArea=(polygons(gr1).area+polygons(gr2).area)/2;

        features=[features...
            int int/polygons(gr1).area int/polygons(gr2).area...
            int/avgArea sum(in1) sum(in2)];
    else
        features=[features 0 0 0 0 0 0];
    end
    
    strGr1=num2str(gr1);
    strGr2=num2str(gr2);
    
    featureNames=horzcat(featureNames,{...
        ['IntersectionArea_G' strGr1 '&' strGr2],...
        ['RatioIntersectedArea_G' strGr1 '&' strGr2 '_ToArea_G' strGr1],...
        ['RatioIntersectedArea_G' strGr1 '&' strGr2 '_ToArea_G' strGr2],...
        ['RatioIntersectedArea_G' strGr1 '&' strGr2 '_ToAvgArea_G' strGr1 '&' strGr2],...
        ['NumCentroidsClusters_G' strGr1 '_InConvHull_G' strGr2],...
        ['NumCentroidsClusters_G' strGr2 '_InConvHull_G' strGr1]...
        });
    
end    

end

