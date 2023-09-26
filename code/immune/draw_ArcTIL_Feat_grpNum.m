function [Case,Features]=draw_ArcTIL_Feat_grpNum(I,M,H,E,S,E_HM,lympModel_WSI,draw_option,visFile)


if calc_frac(E)+calc_frac(S)<0.2 || calc_frac(M)<=0
    Case='Blank';
else
    %% epithelial patches
    if ( eps+calc_frac(E))/(eps+calc_frac(S))>3   %%% this patch contains mainly epithelial
        Case='Epithelial';
        ROI=E;
    end
    %% stromal patches
    if ( eps+calc_frac(S))/(eps+calc_frac(E))>3   %%% this patch contains mainly epithelial
        Case='Stromal';
        ROI=S;
    end
    %% tumor edge patches
    if ( eps+calc_frac(E))/(eps+calc_frac(S))<3 &&( eps+calc_frac(S))/(eps+calc_frac(E))<3   %%% this patch contains mainly epithelial
        Case='TomurEdge';
        ROI=S+E;
    end
end
if strcmp(Case,'Blank')
    fprintf('empty patch \n')
    Features=zeros(1172,1);
    
else
    %% classify the cells in ROI
    [nucCentroids,nucFeatures,~] = get7NucLocalFeatures(I,ROI.*M);
    isLymph = (predict(lympModel_WSI.model,nucFeatures(:,1:7)))==1;
    cent=round(nucCentroids);
    numCent=length(cent);
    epiNuc=false(numCent,1);
    
    if numCent<3
        
        fprintf('empty patch \n')
        Features=zeros(1172,1);
    else
        
        for c=1:numCent
            epiNuc(c)=E(cent(c,2),cent(c,1));
        end
        coords= {   nucCentroids(~isLymph & epiNuc,:),...
            nucCentroids(isLymph & ~epiNuc,:),...
            nucCentroids(isLymph & epiNuc,:),...
            nucCentroids(~isLymph & ~epiNuc,:),...
            };
        
        alpha=0.37*ones(1,4);
        r=.185;
        
        %% draw centroids, graphs, convex hull for all families
        if draw_option==1
            classes=zeros(1,numCent);
            classes(isLymph & ~epiNuc)=1;
            classes(isLymph & epiNuc)=2;
            classes(~isLymph & ~epiNuc)=3;
            colors = {...
                [1, 0.54, 0],...
                [0 .81 .91],...
                [0.45, 0.8, 0],...
                [.1 0 .7]};
            V30= ESW_maker2(E,S,H);
            V40=(V30+I)/2;
            V41=ROImaker(V40,ROI);
            V41=(V41+ones(size(V41)))/2;

       
SA_drawGraphsAndConvexHull_all_class( V41,coords,colors,r,alpha,visFile,1)
saveas(gcf,[visFile,'/','1.png'])
       
SA_drawGraphsAndConvexHull_all_class( V41,coords,colors,r,alpha,visFile,2)
saveas(gcf,[visFile,'/','2.png'])
       
SA_drawGraphsAndConvexHull_all_class( V41,coords,colors,r,alpha,visFile,3)
saveas(gcf,[visFile,'/','3.png'])
       
SA_drawGraphsAndConvexHull_all_class( V41,coords,colors,r,alpha,visFile,4)
saveas(gcf,[visFile,'/','4.png'])



        end
        
    end
    
end








