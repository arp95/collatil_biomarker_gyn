function [ centroids,features,featureNames ] = get7NucLocalFeatures( image, mask )
%GETNUCLOCALFEATURES Summary of this function goes here
%   Detailed explanation goes here

mask=mask(:,:,1);
mask = logical(mask);
mask = bwareaopen(mask, 30);

% orderZernikePol=7;

image=normalizeStaining(image);
grayImg=rgb2gray(image);

regionProperties = regionprops(mask,grayImg,'Centroid','Area',...
    'BoundingBox','Eccentricity','EquivDiameter','Image',...
    'MajorAxisLength','MaxIntensity','MeanIntensity','MinIntensity',...
    'MinorAxisLength','Orientation','PixelValues');

centroids = cat(1, regionProperties.Centroid);

medRed=[];
% medGreen=[];
% medBlue=[];
entropyRed=[];
% medIntensity=[];
% entropyIntensity=[];
% harFeat=[];
% edgeMedIntensity=[];
% zernFeat=[];

nucleiNum=size(regionProperties,1);
for i=1:nucleiNum
    nucleus=regionProperties(i);
    bbox = nucleus.BoundingBox;
    bbox = [round(bbox(1)) round(bbox(2)) (bbox(3) - 1) (bbox(4) - 1)];
    roi = image(bbox(2) : bbox(2) + bbox(4), bbox(1) : bbox(1) + bbox(3), :);
    per = bwperim(nucleus.Image);
    
    gray=rgb2gray(roi);
    R=roi(:,:,1);
    G=roi(:,:,2);
    B=roi(:,:,3);
    
    R=R(nucleus.Image == 1);
    G=G(nucleus.Image == 1);
    B=B(nucleus.Image == 1);
    grayPix=gray(nucleus.Image == 1);
    perPix=gray(per==1);
    
    % Intensity features:
    medRed = [medRed;median(double(R))];
%     medGreen = [medGreen;median(double(G))];
%     medBlue = [medBlue;median(double(B))];
%     medIntensity=[medIntensity;median(double(grayPix))];
%     edgeMedIntensity=[edgeMedIntensity;median(double(perPix))];
    
    % Texture features:
    
    % Entropies
    entropyRed=[entropyRed; getNucEntropy(R)];
%     entropyIntensity=[entropyIntensity;getNucEntropy(grayPix)];
    
    % Haralick features
%     glcm = graycomatrix(gray);
%     harFeat=[harFeat;haralickTextureFeatures(glcm,1:14)'];
    
    % Zernike moments
%     [w,h]=size(nucleus.Image);
%     sqRoi=getSquareRoi(grayImg,nucleus.Centroid,w,h);
%     zernFeat=[zernFeat;getZernikeMomentsImg(sqRoi,orderZernikePol)];
    
end

% ratioMedRB=medRed./medBlue;
% ratioMedRG=medRed./medGreen;

ratioAxes=[regionProperties.MajorAxisLength]./[regionProperties.MinorAxisLength];

features = horzcat([regionProperties.Area]',[regionProperties.Eccentricity]', ...
    ratioAxes',medRed,entropyRed,double([regionProperties.MinIntensity]'),...
    double([regionProperties.MaxIntensity]'));

% features = horzcat([regionProperties.Area]',[regionProperties.Eccentricity]', ...
%     ratioAxes',medRed,entropyRed,double([regionProperties.MinIntensity]'),...
%     double([regionProperties.MaxIntensity]'),[regionProperties.EquivDiameter]',...
%     [regionProperties.Orientation]',entropyIntensity,medIntensity,edgeMedIntensity,...
%     ratioMedRB,ratioMedRG,harFeat,zernFeat...
%     );

% numZernikePol=size(zernFeat,2)/2;
% zernNames={};
% for i=1:numZernikePol
%     num=num2str(i);
%     zernNames=[zernNames, ['ZernPol' num '_A'], ['ZernPol' num '_Phi']];
% end

% harNames={'AngularSecondMoment','Contrast','Correlation',...
%     'Variance','Homogeneity','SumAverage','SumVariance','SumEntropy',...
%     'Entropy','DifferenceVariance','DifferenceEntropy','InfoMeasureCorrI',...
%     'InfoMeasureCorrII','MaxCorrCoeff'};

featureNames=[{'Area','Eccentricity','RatioAxes','MedianRed','EntropyRed',...
    'MinIntensity','MaxIntensity'}];
    
% %     'EquivDiameter','Orientation',...
% %     'EntropyIntensity','MedianIntensity','EdgeMeanIntensity','RatioMedianRedBlue',...
% %     'RatioMedianRedGreen'}];
%featureNames=[{'Area','Eccentricity','RatioAxes','MedianRed','EntropyRed',...
%    'MinIntensity','MaxIntensity','EquivDiameter','Orientation',...
%    'EntropyIntensity','MedianIntensity','EdgeMeanIntensity','RatioMedianRedBlue',...
%    'RatioMedianRedGreen'},harNames,zernNames];

end

