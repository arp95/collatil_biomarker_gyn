function [spaFeat,spaFeatNames] = getTILFeaturesV3( curTile,M,Model,TIL_maskFile,nonTIL_maskFile ,TILVsNonTIL_maskFile)



[nucleiCentroids,nucFeatures,~] = getNucLocalFeatures(curTile,M);


isLymphocyte = (predict(Model,nucFeatures(:,1:7)))==1;

lympCentroids=nucleiCentroids(isLymphocyte==1,:);
nonLympCentroids=nucleiCentroids(isLymphocyte~=1,:);
nucAreas=nucFeatures(:,1);
lympAreas=nucAreas(isLymphocyte==1);

[lympMask,nonLympMask]=lympVsNonLympMask(lympCentroids,curTile, M );
lympMask=im2uint8(lympMask);

% drawNucleiCentroidsByClass( curTile,nucleiCentroids,isLymphocyte,2 )
% saveas(gcf,[TILVsNonTIL_maskFile])


imwrite(lympMask,TIL_maskFile)
imwrite(nonLympMask,nonTIL_maskFile)
[spaFeat,spaFeatNames]=getSpaTILFeatures(lympCentroids,nonLympCentroids);

end