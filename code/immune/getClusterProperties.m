function [centroids,polygons,areas,densities]=getClusterProperties(clusters,nodes)

numClusters=length(clusters);

centroids=zeros(numClusters,2);
polygons=cell(numClusters,1);
areas=zeros(numClusters,1);
densities=zeros(numClusters,1);

for i = 1:numClusters
    member = clusters{i};
    col = nodes(member,1);
    row = nodes(member,2);
    
    [k,a] = convhull(col,row);
    
    areas(i)=a;
    densities(i)=(length(col)/a);
    
    cx=mean(col(k));
    cy=mean(row(k));
    centroids(i,:)=[cx cy];
    polygons{i}=[col(k) row(k)];
    
    %if plot
    %    plotClusters(col(k),row(k),cx,cy,i,gr);
    %end
end

end