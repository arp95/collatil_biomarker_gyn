function [ features,featureNames ] = getSpaTILFeatures_v3(coords,alpha,r,neigborhoodSize,groupingThreshold)

%% Parameter management


% if nargin<2
%     alpha=.42;
% end
if nargin<3
    r=.185;
end
if nargin<4
    neigborhoodSize=5;
end

if nargin<5
    groupingThreshold=.005;
end

%% Variable initialization

% This value defines the maximum number of close neighbors used to compute
% the intersection between clusters. It was set to 5 for performance.
maxNeigborsInters=5;

numGroups=length(coords);
featureNames=cell(1,numGroups);
clustPerGroup=zeros(1,numGroups);

%% Building clusters
groups=struct;
for i=1:numGroups

    groups(i).nodes=coords{i};
    [~,~,~,~,groupMatrix] = construct_nodesCluster_new(struct('centroid_r',coords{i}(:,2)','centroid_c',coords{i}(:,1)'), alpha(i), r);
    [~,~,groups(i).clusters] = networkComponents(groupMatrix);
        
    % Discarding clusters with less than 3 nodes
    groups(i).clusters(cellfun(@length,groups(i).clusters)<=2)=[];
        
    % Getting cluster properties (centroids, polygons, areas, and densities)
    [groups(i).clusterCentroids,groups(i).clusterPolygons,...
    groups(i).areas,groups(i).densities]=getClusterProperties(groups(i).clusters,groups(i).nodes);
    
     % Getting clusters by group
     clustPerGroup(i)=length(groups(i).clusters);
     featureNames{i}=['NumClusters_G' num2str(i)];
end

%% Identifying closest neighbors per group
for i=1:numGroups
     groups(i).neighborsPerGroup=getClosestNeighborsByGroup(groups,i);
end

%% Identifying absolute closest neighbors
maxNumClust=max(clustPerGroup);
for i=1:numGroups
    groups(i).absoluteClosest=getAbsoluteClosestNeighbors(groups,i,maxNumClust);
end

%% Extracting cluster-related features

[densFeat,densFeatNames]=getClusterDensityMeasures_v2(groups);
[intersClustFeat,intersClustFeatNames]=getClusterIntersectionMeasures(groups,maxNeigborsInters);
[richFeat,richFeatNames]=getNeighborhoodMeasures(groups,neigborhoodSize,maxNumClust);

%% Extracting group-related features
[graphFeat,graphFeatNames]=getGraphFeatures(groups);
[intersGroupFeat,intersGroupFeatNames]=getIntersectionGroups(groups);
[groupingFeat,groupingFeatNames]=getGroupingFactorByGroup(groups,groupingThreshold);

%% Compiling features

features=[clustPerGroup,densFeat,intersClustFeat,richFeat,graphFeat,...
    intersGroupFeat,groupingFeat];

featureNames=[featureNames,densFeatNames,intersClustFeatNames,...
    richFeatNames,graphFeatNames,intersGroupFeatNames,groupingFeatNames];


end