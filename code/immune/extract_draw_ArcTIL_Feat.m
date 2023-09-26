function [Case, featNames, Features]=extract_draw_ArcTIL_Feat(I,M,H,E,S,E_HM,lympModel_WSI,draw_option,visFile, name)

if calc_frac(E)+calc_frac(S)<0.2 || calc_frac(M)<=0
    Case='Blank';
else
    %% epithelial patches
    if ( eps+calc_frac(E))/(eps+calc_frac(S))>3   %%% this patch contains mainly epithelial
        Case='Epithelial';
        ROI=S;
    end
    %% stromal patches
    if ( eps+calc_frac(S))/(eps+calc_frac(E))>3   %%% this patch contains mainly epithelial
        Case='Stromal';
        ROI=S;
    end
    %% tumor edge patches
    if ( eps+calc_frac(E))/(eps+calc_frac(S))<3 &&( eps+calc_frac(S))/(eps+calc_frac(E))<3   %%% this patch contains mainly epithelial
        Case='TomurEdge';
        ROI=S;
    end
end

featNames = ones(1,1);
Features = ones(1,1);
if strcmp(Case,'Blank')
    fprintf('empty patch \n');
    featNames = ones(1,1);
    Features = ones(1,1);
    
else
    [nucCentroids,nucFeatures,~] = get7NucLocalFeatures(I,M);
    cent=round(nucCentroids);
    numCent=length(cent);
    epiNuc=false(numCent,1);
    
    if numCent<3
        fprintf('empty patch \n')
        Features=zeros(3516,1);
    else
        isLymph = (predict(lympModel_WSI.model,nucFeatures(:,1:7)))==1;
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
        [Features,featNames]=getSpaTILFeatures_v3(coords,alpha,r);
        featNames = reshape(featNames,[size(featNames,2), size(featNames,1)]);
    end
end