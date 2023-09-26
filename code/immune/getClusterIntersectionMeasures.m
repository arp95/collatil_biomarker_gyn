function [features,featureNames]=getClusterIntersectionMeasures(groups,n)
% groups - Struct containing data regarding each group
% n - The algorithm will check if there is intersection with a maximum of n
% close clusters.

features=[];
featureNames={};

numGroups=length(groups);

comb = combnk(1:numGroups,2);
numComb=size(comb,1);
for i=1:numComb
    
    group1=groups(comb(i,1));
    group2=groups(comb(i,2));
    
    %-- Being I=instersected area, A=area of cluster 1, B=area of cluster 2
    %-- intAreas = I
    %-- intRel1 = I/A
    %-- intRel2 = I/B
    %-- intRel3 = I/((A+B)/2)
    
    intAreas=[];
    intRel1=[];
    intRel2=[];
    intRel3=[];
    
    numClust1=length(group1.clusters);
    for j=1:numClust1
        pol1=group1.clusterPolygons{j};
        area1=group1.areas(j);
        %closest=group1.closest(comb(i,2)).idx(j,:);
        closest=group1.neighborsPerGroup(comb(i,2)).closest(j,:);
        
        numClosest=length(closest);
        if numClosest<n
            n=numClosest;
        end
        
        numClust2=length(group2.clusters);
        if n>numClust2
            n=numClust2;
        end
        
        for k=1:n
            pol2=group2.clusterPolygons{closest(k)};
            area2=group2.areas(closest(k));
            
            polyarray1 = polyshape(pol1);
            polyarray2 = polyshape(pol2);
            polyout = intersect([polyarray1 polyarray2]);
            int=polyarea(polyout.Vertices(:,1),polyout.Vertices(:,2));
            
            if int~=0
                intAreas=[intAreas;int];
                intRel1=[intRel1;int/area1];
                intRel2=[intRel2;int/area2];
                intRel3=[intRel3;2*int/(area1+area2)];
            end
        end
    end
    
    if isempty(intAreas)
        features=[features zeros(1,8*4)];
    else
        features=[features getFeatureStats(intAreas)...
            getFeatureStats(intRel1) getFeatureStats(intRel2)...
            getFeatureStats(intRel3) ];
    end
    
    gr1=num2str(comb(i,1));
    gr2=num2str(comb(i,2));
    stats={'Total','Mean','Std','Median','Max','Min','Kurtosis','Skewness'};
    meas={['IntersectedAreaClusters_G' gr1 '&' gr2],...
        ['RatioIntersectedAreaClusters_G' gr1 '&' gr2 '_ToArea_G' gr1],...
        ['RatioIntersectedAreaClusters_G' gr1 '&' gr2 '_ToArea_G' gr2],...
        ['RatioIntersectedAreaClusters_G' gr1 '&' gr2 '_ToAvgArea_G' gr1 '&' gr2]};
    
    for ms=1:length(meas)
        for st=1:length(stats)
            featureNames=horzcat(featureNames, {[stats{st},meas{ms}]});
        end
    end
    
end

end