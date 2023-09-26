clc
close all
clear 
addpath(genpath('pwd'))
%% begin with reading I (original image, M (nuclei mask) and Epi (epithelial mask))
I=im2double(imread('ArcTIL_Example\I.png'));
M=im2double(imread('ArcTIL_Example\M.png'));
Epi=im2double(imread('ArcTIL_Example\epi.png'));
H= (ones(3000,3000)); %%% once you have HistoQC mask, resize it and use it as H variable
E=(Epi.*H);
S=((1-Epi).*H);




hh='C:\Users\CASE\Desktop\Ovarian\Ovarian_Codes\ArcTIL_clusters_Arpit\lymp_svm_matlab_wsi.mat';
lympModel_WSI=load(hh);

visFile='ArcTIL_Example\Vis';
[Case,Features]=extract_draw_ArcTIL_Feat(I,M,H,E,S,E,lympModel_WSI,1,visFile);

