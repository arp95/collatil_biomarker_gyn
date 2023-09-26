function [features,featureNames]=getClusterDensityMeasures_v2(groups)

features=[];
featureNames={};

numGroups=length(groups);

stats={'Total','Mean','Std','Median','Max','Min','Kurtosis','Skewness'};
meas={'AreaClusters_G','DensityClusters_G'};

for i=1:numGroups
    
    areas=groups(i).areas;
    dens=groups(i).densities;
    
    if ~isempty(areas)
        features=[ features getFeatureStats(areas) getFeatureStats(dens) ];
    else
        features=[ features zeros(1,2*8) ];
    end

    for ms=1:length(meas)
        for st=1:length(stats)
            featureNames=horzcat(featureNames, {[stats{st} meas{ms} num2str(i)]});
        end
    end
    
end

end