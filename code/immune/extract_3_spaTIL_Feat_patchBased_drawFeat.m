function [Case,Features]=extract_3_spaTIL_Feat_patchBased_drawFeat(I,M,H,E,S,lympModel_WSI,draw_option)

if nargin<7
    draw_option=0;
end

if calc_frac(E)+calc_frac(S)==0 || calc_frac(M)<=0
    Case='Blank';
else
    %% epithelial patches
    if ( eps+calc_frac(E))/(eps+calc_frac(S))>2   %%% this patch contains mainly epithelial
        Case='Epithelial';
        ROI=E;
    else
        Case='Stromal';
        ROI=S;
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
        
        alpha=[0.4,0.37,0.38,0.38];
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
            drawNucContoursByClass_SA2(M,V41,nucCentroids,classes,colors);
            SA_drawGraphsAndConvexHull(I,V30,V41, coords,colors,r,alpha)
        end
        %% extracting features
        [Features,featNames]=getSpaTILFeatures_v3(coords,alpha,r);
        featNames = reshape(featNames,[size(featNames,2), size(featNames,1)]);
    end
    
end








