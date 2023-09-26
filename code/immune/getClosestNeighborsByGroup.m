function neighbors = getClosestNeighborsByGroup(groups,groupId)
%GETCLOSESTNEIGHBORSGROUP Summary of this function goes here
%   Detailed explanation goes here

numGroups=length(groups);
neighbors=struct;

for j=1:numGroups
    
    if groupId==j
        dist = squareform(pdist(groups(groupId).clusterCentroids));
        dist(dist==0)=Inf;
    else
        dist = pdist2(groups(groupId).clusterCentroids,groups(j).clusterCentroids);
    end
    
    if length(groups(j).clusters)==1
        numNeigh=length(dist);
        if groupId==j
            numNeigh=numNeigh-1;
        end
        neighbors(j).closest=ones(numNeigh,1);
        neighbors(j).sortedDist=dist(1:numNeigh);
    else
        numNeigh=size(dist,2);
        if groupId==j
            numNeigh=numNeigh-1;
        end
        [sortedDist,idx] = sort(dist');
        neighbors(j).closest=idx(1:numNeigh,:)';
        neighbors(j).sortedDist=sortedDist(1:numNeigh,:)';
    end
        
end

end