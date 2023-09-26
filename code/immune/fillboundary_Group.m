function [col]=fillboundary_Group(members,nodes,ccc)
numMembers=length(members);
for i = 1:numMembers
    member = members{i};
    col = nodes.centroid_c(member)';
    row = nodes.centroid_r(member)';
    
    if length(col) >  2
        [k,~] = boundary(col',row',1);
        hold on
        plot(col(k),row(k),'color',ccc, 'LineWidth',4);
        fill(col(k),row(k),ccc,'facealpha',.5)
        
    end
end

end

