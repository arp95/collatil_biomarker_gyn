function SA_drawGraphsAndConvexHull_all_class(V41, coords,colors,r,a,visFile,grpNum)
numGroups=length(coords);

MM=cell(numGroups,1);
for i= grpNum
    alpha=a(i);
    [~,~,~,~,groupMatrix] = construct_nodesCluster_new(struct('centroid_r',coords{i}(:,2)','centroid_c',coords{i}(:,1)'), alpha, r);
    MM{i}=groupMatrix;
end


figure
% imshow(ones(size(V41)),'Border','tight');
imshow(V41,'Border','tight');
hold on;
drawGraph_standard(coords,MM,colors);

hold on
numGroups=length(coords);
MM=cell(numGroups,1);
i=grpNum;
alpha=a(i);
xx=cell2mat(coords(:,i)');
Nodes = struct('centroid_r',xx(:,2),'centroid_c',xx(:,1));
[~,~,~,~,edges,~,~] = construct_nodesCluster_new(struct('centroid_r',coords{i}(:,2)','centroid_c',coords{i}(:,1)'), alpha, r);
groupMatrix= edges;
MM{i}=groupMatrix;
[~,~,groupMembers] = networkComponents(groupMatrix);
[~,~,~,~,~]=fillConvexHull_Group(groupMembers,Nodes,colors{i});







 