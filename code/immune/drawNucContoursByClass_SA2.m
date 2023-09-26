function drawNucContoursByClass_SA2( M,I,centroids, classes,colors,  tickness )
if nargin<6
    tickness=3;
end
numCent=length(centroids);

boundaries = bwboundaries(M);
numNucMask = size(boundaries,1);
imshow(I,'Border','tight');
hold on;
for i=1:numNucMask
    b = boundaries{i};
    w=min(b(:,1));
    x=max(b(:,1));
    y=min(b(:,2));
    z=max(b(:,2));
    for j=1:numCent
        if centroids(j,1)>y && centroids(j,1)<z && centroids(j,2)>w && centroids(j,2)<x
            plot(b(:,2),b(:,1),'color',colors{classes(j)+1},'LineWidth',tickness);
        end
    end
    
end
hold off;
end

