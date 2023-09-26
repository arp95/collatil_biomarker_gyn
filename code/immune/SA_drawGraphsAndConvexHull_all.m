function SA_drawGraphsAndConvexHull_all(I,V30,V41, coords,colors,r,a,visFile)
numGroups=length(coords);

MM=cell(numGroups,1);
for i=1:numGroups
    alpha=a(i);
    [~,~,~,~,groupMatrix] = construct_nodesCluster_new(struct('centroid_r',coords{i}(:,2)','centroid_c',coords{i}(:,1)'), alpha, r);
    MM{i}=groupMatrix;
end

figure
imshow((V41),'Border','tight');
hold on;
drawGraph_standard(coords,MM,colors);
drawGraph_boundary_standard(coords,colors,a,r,3,3);
saveas(gcf,[visFile, '_4.png'])

figure
imshow(ones(size(V41)),'Border','tight');
hold on;
drawGraph_standard(coords,MM,colors);
drawGraph_convexHull_standard(coords,colors,a,r,3,3);
saveas(gcf,[visFile, '_5.png'])

figure
imshow(ones(size(V41)),'Border','tight');
hold on;
drawGraph_standard(coords,MM,colors);
drawGraph_boundary_standard(coords,colors,a,r,3,3);
saveas(gcf,[visFile, '_6.png'])




 