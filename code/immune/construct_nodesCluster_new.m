function [VX,VY,x,y,edges,xloc,convH] = construct_nodesCluster_new(bounds,alpha,r)
%Cell Cluster Graph

X = [bounds(:).centroid_r; bounds(:).centroid_c];

%distance matrix
D = pdist(X','euclidean');%constructing the distance of each points(center of nucleis) to each other

D = squareform(D);% transforming the previous D to matrix form, D is symmetric
% probability matrix
P = D.^-alpha; %probability matrix = distance matrix?

% a = unique(unique(P));
% b = unique(unique(D));
% plot(a,'r')
% hold on
% plot(b,'g')
% hold off
% close all

VX = []; x = [];
VY = []; y = [];
%define edges
edges = zeros(size(D));
z=1;
t=1;
convH = cell(0);
tt= 1;
% convTemp = [];
% convTemp2 = [];

xloc=[];

for i = 1:length(D)-1%only need to compute the distance of second last with the last, no needs to iterate to last, so length()-1
    count = 0;
    for j = i+1:length(D) %do not need to compute self-to-self, so starting from the next one
        if r < P(i,j) % if probability is greater than threshold set
            edges(i,j) = 1; %
            VX(z,:) = [bounds.centroid_r(i); bounds.centroid_r(j)];
            %             [bounds.centroid_r(i); bounds.centroid_r(j)]
            xloc(z,:) = [i;j];
            %             [bounds.centroid_c(i); bounds.centroid_c(j)]
            VY(z,:) = [bounds.centroid_c(i); bounds.centroid_c(j)];
            
% % % % % % % % % % %            plot([bounds.centroid_c(i); bounds.centroid_c(j)]',[bounds.centroid_r(i); bounds.centroid_r(j)]', 'g-', 'LineWidth', 1.5);
            
            x(t) = bounds.centroid_r(i);
            y(t) = bounds.centroid_c(i);
            t=t+1;
            
            x(t) = bounds.centroid_r(j);
            y(t) = bounds.centroid_c(j);
%             convTemp = [convTemp;[x(t),y(t)]];
            t = t+1;
            
            z=z+1;
            
            count = count + 1;
        end
    end
%     conVetx = [convTemp;[bounds.centroid_r(i),bounds.centroid_c(i)]];
%     if size(conVetx,1) > 2
%         k = convhull(conVetx);
%         plot(conVetx(k,2),conVetx(k,1),'y-', 'LineWidth', 3);
%         convH{tt} = conVetx;
%         tt = tt + 1;
%         convTemp2 = [convTemp2; conVetx];
%     end
%     conVetx = [];
%     convTemp = []; 
end


%params.r = r;
%params.alpha = alpha;