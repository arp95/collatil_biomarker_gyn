%% parameters setting
 
% pointAnnoName='C:\Users\CASE\OneDrive\codeSample\1000625.xml';
% pointAnno=getAnnotationsimp(pointAnnoName);
% tileSize=2000;
% tileCoor=[round(pointAnno.Y)+1,round(pointAnno.Y)+tileSize;round(pointAnno.X)+1,round(pointAnno.X)+tileSize];
% tumorTile=imread([wsiPath,wsiName,'.svs'],'PixelRegion',{[tileCoor(1,1) tileCoor(1,2)],[tileCoor(2,1),tileCoor(2,2)]});
% strMask=~epiMask(round(tileCoor(1,1)/4): round(tileCoor(1,2)/4),round(tileCoor(2,1)/4): round(tileCoor(2,2)/4));
% strMask=imresize(strMask,[size(tumorTile,1),size(tumorTile,1)]);
% imshow(labeloverlay(tumorTile,imresize(strMask,[size(tumorTile,1),size(tumorTile,1)]),'transparency',0.7))
% imwrite(tumorTile,'C:\Users\CASE\OneDrive\codeSample\tumorSample.png');
% imwrite(strMask,'C:\Users\CASE\OneDrive\codeSample\stromaMask.png');


strMask=imread('C:\Users\CASE\OneDrive\codeSample\stromaMask.png');
tumorSample=imread('C:\Users\CASE\OneDrive\codeSample\tumorSample.png');
winSize=200;% size of windows from which the collagen fiber disorder was measured
filterScale=3;% kernel size of the BIF model
orientCooccurScheme=1;% considering the area of each detected collagen fiber when quatifying the orientation disorder.
featureDescriptor=6; % the 6th category of the Basic Image Feature corresponds to the dark linear structure.
orienBinInterval=10;% discritize the continous orientation angle by interval of 10. 
orientNum=180/orienBinInterval;


%% extract collagen fiber mask
fragThresh=filterScale*10;% remove detected collagen fragments with an area lower than the predefined threshold
[bifs] =computeBIFs(tumorSample,filterScale,.1,1); % use BIF based model to extract the linear structures which was used as the representative of collagen fibers
collagenMask=bifs==featureDescriptor;
[height,width]=size(collagenMask);       
collagenMask=(collagenMask & strMask); % remove the detected colaggen fibers in nonstroma region
collagenMask=bwareaopen(collagenMask,fragThresh);
imshow(labeloverlay(tumorSample,collagenMask,'transparency',0,'Colormap',[0,1,0])) % overlay the collagen fiber mask on top of the tumor sample.



u= x(i) + lineLength * cosd(discrete_angles(i));
v= y(i) - lineLength * sind(discrete_angles(i));
quiver(x(i),y(i),u-x(i),v-y(i),'color','r','LineWidth',2)

%% collagen centroid and orientation information extraction
collogenProps=regionprops('table',collagenMask,'Centroid','Orientation','Area');
colgCenter=collogenProps.Centroid;
colgArea=collogenProps.Area;
colgOrient=collogenProps.Orientation;
colgOrient=fix(colgOrient/orienBinInterval);
colgOrient=colgOrient+9;
win_size_ind=0;    
  
%% CFOD feature extraction                   
stepSize=winSize/2; % cfod features were extracted based on a sliding window fashion, 
disp('calculating CFOD')
win_x_ind=0;
for win_x=1:step_size:width-step_size+1
    win_x_ind=win_x_ind+1;
    win_y_ind=0;
    for win_y=1:step_size:height-step_size+1
       win_y_ind=win_y_ind+1;
       p_orient_occur=[];
       strRatioMap(win_y_ind,win_x_ind)=length(find(strMask(win_y:win_y+win_size-1,win_x:win_x+win_size-1)))/(win_size^2);
       inwinColgInd=find(colgCenter(:,1)>=win_x & colgCenter(:,1)<win_x+win_size-1 & colgCenter(:,2)>=win_y & colgCenter(:,2)<win_y+win_size-1); 
       inwinColgOrient=colgOrient(inwinColgInd); 
       inwinColgArea=colgArea(inwinColgInd);
       if length(inwinColgOrient)>=5
        [orient_occur_feats]=contrast_entropy(inwinColgOrient,inwin_collagen_area,orient_num,orient_cooccur_scheme_ind);     
             if isfield(orient_occur_feats,'val')
                    cfodMap(win_y_ind,win_x_ind)=orient_occur_feats.val; 
         end 
       end
   end   
end

cfodMapMoveAvg=movmean(cfodMap,2,1,'omitnan','Endpoint','discard'); % feature was calculated in sliding window version
cfodMapMoveAvg=movmean(cfodMapMoveAvg,2,2,'omitnan','Endpoint','discard');




