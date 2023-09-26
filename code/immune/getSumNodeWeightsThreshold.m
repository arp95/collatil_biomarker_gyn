function vect = getSumNodeWeightsThreshold( feature,distance,threshold )
%GETSUMNODEWEIGHTSTHRESHOLD Computes the sum of the inverse of the
%distances for each node in the graph using a threshold. If the distance
%between two nodes exceeds such threshold, the edge is not added.
 
% getting distances, removing 0 
dist=pdist(feature,distance);
dist(dist==0)=1;
dist=dist.^-1;

%normalizing
%dist=dist/max(dist);
%applying threshold
dist(dist<threshold)=0;

%computing the value of each node
vect=sum(squareform(dist));

end

