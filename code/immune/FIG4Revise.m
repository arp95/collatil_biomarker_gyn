clc
close all
clear 
addpath(genpath('pwd'))
%% begin with reading I (original image, M (nuclei mask) and Epi (epithelial mask))
I=im2double(imread('G:\My Drive\My Courses\Journal Paper\2021-09-08- Journal for ImmunoTherapy of Cancer (JITC)\Figure 4\TCGA-3P-A9WA_24_54_7.png'));
M=im2double(imread('G:\My Drive\My Courses\Journal Paper\2021-09-08- Journal for ImmunoTherapy of Cancer (JITC)\Figure 4\TCGA-3P-A9WA_24_54_8.png'));
e=im2double(imread('G:\My Drive\My Courses\Journal Paper\2021-09-08- Journal for ImmunoTherapy of Cancer (JITC)\Figure 4\TCGA-3P-A9WA_24_54_1.png'));
BW=e(:,:,1)<.5;
Epi= double(imresize(BW,[3000 3000]));
H= (ones(3000,3000)); %%% once you have HistoQC mask, resize it and use it as H variable
E=(Epi.*H);
S=((1-Epi).*H);
hh='C:\Users\CASE\Desktop\Ovarian\Ovarian_Codes\ArcTIL_clusters_Arpit\lymp_svm_matlab_wsi.mat';
lympModel_WSI=load(hh);
visFile='G:\My Drive\My Courses\Journal Paper\2021-09-08- Journal for ImmunoTherapy of Cancer (JITC)\Figure 4\Vis';
draw_ArcTIL_Feat_grpNum(I,M,H,E,S,E,lympModel_WSI,1,visFile);



I=im2double(imread('G:\My Drive\My Courses\Journal Paper\2021-09-08- Journal for ImmunoTherapy of Cancer (JITC)\Figure 4\TCGA-23-1032_24_54_7.png'));
M=im2double(imread('G:\My Drive\My Courses\Journal Paper\2021-09-08- Journal for ImmunoTherapy of Cancer (JITC)\Figure 4\TCGA-23-1032_24_54_8.png'));
e=im2double(imread('G:\My Drive\My Courses\Journal Paper\2021-09-08- Journal for ImmunoTherapy of Cancer (JITC)\Figure 4\TCGA-23-1032_24_54_1.png'));
BW=e(:,:,1)<.5;
Epi= double(imresize(BW,[3000 3000]));
H= (ones(3000,3000)); %%% once you have HistoQC mask, resize it and use it as H variable
E=(Epi.*H);
S=((1-Epi).*H);
visFile='G:\My Drive\My Courses\Journal Paper\2021-09-08- Journal for ImmunoTherapy of Cancer (JITC)\Figure 4\Vis2';
draw_ArcTIL_Feat_grpNum(I,M,H,E,S,E,lympModel_WSI,1,visFile);


