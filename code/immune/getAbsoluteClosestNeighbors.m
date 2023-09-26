function absoluteClosest = getAbsoluteClosestNeighbors(groups,groupId,maxClust)
%GETABSOLUTECLOSESTNEIGHBORS Summary of this function goes here
%   Detailed explanation goes here

numGroups=length(groups);
numClusters=length(groups(groupId).clusters);
absoluteClosest=struct;

for j=1:numClusters
    distMat=Inf(numGroups,maxClust);    
    for k=1:numGroups
        if ~isempty(groups(groupId).neighborsPerGroup(k).sortedDist)
            dist=groups(groupId).neighborsPerGroup(k).sortedDist(j,:);
            distMat(k,1:length(dist))=dist;
        end        
    end
    [~,idx]=sort(distMat(:));
    [x, y] = ind2sub(size(distMat), idx);
    
    numIdx=sum(sum(~isinf(distMat)));
    close=zeros(numIdx,2);    
    for k=1:numIdx        
        if size(groups(groupId).neighborsPerGroup(x(k)).closest,2)==1
            close(k,:)=[x(k),groups(groupId).neighborsPerGroup(x(k)).closest(y(k))];
        else
            close(k,:)=[x(k),groups(groupId).neighborsPerGroup(x(k)).closest(j,y(k))];
        end
    end
    absoluteClosest(j).idx=close;
end

end