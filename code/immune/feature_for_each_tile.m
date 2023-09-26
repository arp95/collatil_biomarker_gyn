clear, clc, close all
addpath(genpath('pwd'))


%% CHANGE THESE
HE_patch_folder='../../example/patch/';
ES_folder='../../example/epi_stroma_mask/';
nuc_folder='../../example/nuclei_mask/';
features_store="../../example/immune/features/";

modelPath='./code/immune/';
lympModel_WSI=load('code/immune/lymp_svm_matlab_wsi.mat');
patchList=dir([HE_patch_folder, '*.png']);
numFiles=length(patchList);
numFiles
for n=1:numFiles
    [~,patch_name]=fileparts(patchList(n).name);
    n
    patch_name
    if isfile([nuc_folder,patch_name, '.png' ])
        if isfile([ES_folder,patch_name, '.png' ])
            if isfile([ES_folder,patch_name, '.png' ])
                if isfile([ES_folder,patch_name, '.png' ])
                    I=im2double(imread([HE_patch_folder,patch_name, '.png' ]));
                    E=im2double(imread([ES_folder,patch_name, '.png' ]));
                    H=ones(size(I, 1), size(I, 2));
                    M=zeros(size(I, 1), size(I, 2));
                    m=im2double(imread([nuc_folder,patch_name, '.png' ]));
                    if size(m, 1)==2000
                        M(1:2000, 1:2000) = m;
                    else
                        M = m;
                    end
                    S=im2double(1-E).*H; %stromal mask
                    [c,feat_names, Features]=extract_draw_ArcTIL_Feat(I,M,H,E,S,E,lympModel_WSI,1,'../../Downloads/sample/', patch_name);
                    csvwrite(features_store + patch_name + ".csv",Features);
                end
            end
        end
    end
end