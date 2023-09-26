function [features,featureNames] = getGroupingFactorByGroup(groups,groupingThres)
%GETGROUPINGFACTORBYGROUP Summary of this function goes here
%   Detailed explanation goes here

numGroups=length(groups);

stats={'Total','Mean','Std','Median','Max','Min','Kurtosis','Skewness'};
numStats=length(stats);

features=[];
featureNames={};

for i=1:numGroups
    featVector=getSumNodeWeightsThreshold(groups(i).clusterCentroids,'euclidean',groupingThres);
    
    features=[features,nansum(featVector),nanmean(featVector),nanstd(featVector),...
        nanmedian(featVector),max(featVector),min(featVector),...
        kurtosis(featVector),skewness(featVector)];
    
    for st=1:numStats
        featureNames=horzcat(featureNames, [stats{st} 'GroupingFactor_G' num2str(i)]);
    end
    
end

end