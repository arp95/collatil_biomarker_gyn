function [features,featureNames]=getGraphFeatures(groups)

features=[];
featureNames={};

numGroups=length(groups);

for i=1:numGroups
    centroids=groups(i).clusterCentroids;
    
    nameData=load('GraphFeatureDescription.mat');
    names=strcat('Graph',erase(nameData.GraphFeatureDescription,' '),['_G' num2str(i) ]);
    
    if size(centroids,1)>2
        feat=get_graph_features(centroids(:,1),centroids(:,2));
    else
        feat=zeros(1,length(names));
    end
    
    features=[features,feat];
    featureNames=[featureNames,names];
end

end