function drawGraph_boundary_standard( coords,colors,a,r,lineWidth,markerSize,transpLine,transpMarker )
% imshow(image,'Border','tight');
hold on;
numGroups=length(coords);
MM=cell(numGroups,1);
for i=1:numGroups
    alpha=a(i);
    xx=cell2mat(coords(:,i)');
    Nodes = struct('centroid_r',xx(:,2),'centroid_c',xx(:,1));
     [~,~,~,~,edges,~,~] = construct_nodesCluster_new(struct('centroid_r',coords{i}(:,2)','centroid_c',coords{i}(:,1)'), alpha, r);
   groupMatrix= edges;
     MM{i}=groupMatrix;
    [~,~,groupMembers] = networkComponents(groupMatrix);
    fillboundary_Group(groupMembers,Nodes,colors{i});
end
hold off;
end