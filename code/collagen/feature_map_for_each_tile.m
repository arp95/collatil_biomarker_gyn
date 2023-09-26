%% Author: Arpit Aggarwal
clc
close all
clear 
addpath(genpath('pwd'))


% paths (CHANGE THESE)
patches_dir = "../../example/patch/";
epi_stroma_masks_dir = "../../example/epi_stroma_mask/";
nuclei_masks_dir = "../../example/nuclei_mask/";

% CHANGE THIS to where you want to store the collagen feature maps
collagen_masks_dir = "../../example/collagen/feature_map/600/";

patches = dir(fullfile(patches_dir, '*.png'));
for index = 1:1
    filename = patches(index).name;
    filename

    current_patch = imread(patches_dir + filename);
    epi_stroma_mask = imread(epi_stroma_masks_dir + filename);
    nuclei_mask = imread(nuclei_masks_dir + filename);
    empty_mask = zeros(size(epi_stroma_mask));
    empty_mask(current_patch(:, :, 1) <= 200 & current_patch(:, :, 1) >= 150 & current_patch(:, :, 2) <= 100 & current_patch(:, :, 2) >= 50 & current_patch(:, :, 3) <= 200 & current_patch(:, :, 3) >= 150) = 1;

    % only consider tiles with both epithelium and stromal content
    number_of_zeros = sum(epi_stroma_mask(:) == 0);
    number_of_ones = sum(epi_stroma_mask(:) > 0);
    if im2double(number_of_ones/(number_of_ones + number_of_zeros)) < 0.9
        % hyperparameters for calculating collagen features
        win_size = 600;
        filter_scale = 3;
        orient_cooccur_scheme = 1;
        feature_descriptor = 6;
        orient_bin_interval = 10;
        orient_num = 180 / orient_bin_interval;
        cfod_map = [];

        %% extract collagen fiber mask
        frag_thresh = filter_scale*6;
        [bifs] = compute_bifs(current_patch, filter_scale, .1, 2);
        collagen_mask = bifs == feature_descriptor;
        [height, width] = size(collagen_mask);
        collagen_mask = (collagen_mask & (255 - epi_stroma_mask(:,:,1)));
        collagen_mask = (collagen_mask & (255 - nuclei_mask(:,:,1)));
        collagen_mask = (collagen_mask & (1 - empty_mask));
        collagen_mask = bwareaopen(collagen_mask, frag_thresh);
        patch_collagen_mask = labeloverlay(current_patch, collagen_mask, 'transparency', 0, 'Colormap', [0,0,0]);

        %% collagen orientation information extraction
        collogen_props = regionprops('table', collagen_mask, 'Centroid', 'Orientation', 'Area');
        colg_center = collogen_props.Centroid;
        colg_area = collogen_props.Area;
        colg_orient = collogen_props.Orientation;

        %% feature extraction
        if length(colg_orient) > 0
            colg_orient_bin = fix(colg_orient/orient_bin_interval);
            colg_orient_bin = colg_orient_bin+9;
            win_size_ind = 0;
            step_size = win_size;
            win_x_ind = 0;
            for win_x = 1:step_size:width-win_size+1
                win_x_ind = win_x_ind+1;
                win_y_ind = 0;
                for win_y = 1:step_size:height-win_size+1
                    win_y_ind = win_y_ind+1;
                    p_orient_occur = [];
                    inwin_colg_ind = find(colg_center(:,1)>=win_x & colg_center(:,1)<win_x+win_size-1 & colg_center(:,2)>=win_y & colg_center(:,2)<win_y+win_size-1);
                    inwin_epi_stroma_mask = epi_stroma_mask(win_y:win_y+win_size-1, win_x:win_x+win_size-1);
                    number_of_zeros = sum(inwin_epi_stroma_mask(:) == 0);
                    if number_of_zeros >= 2
                        inwin_colg_orient = colg_orient_bin(inwin_colg_ind); 
                        inwin_colg_area = colg_area(inwin_colg_ind);
                        if length(inwin_colg_orient) >= 2
                            [orient_occur_feats] = disorder_feat_extract(inwin_colg_orient, inwin_colg_area, orient_num, orient_cooccur_scheme);
                            if isfield(orient_occur_feats, 'val')
                                cfod_map(win_y_ind, win_x_ind, :) = orient_occur_feats.val;
                            end 
                        end
                    end
                end
            end
            cfod_map(cfod_map == 0) = NaN;
            cfod_map_size = size(cfod_map);
            if length(cfod_map_size) > 2 && cfod_map_size(1) > 1 && cfod_map_size(2) > 1 && cfod_map_size(3) > 4
                filename = extractBefore(filename, ".png");
                matrix = cfod_map(:, :, 5);
                save(collagen_masks_dir + filename + '.mat', "matrix");
            end

            % plot heatmap
            %figure
            %heat_map = heatmap(cfod_map(:,:,5), 'CellLabelColor','none');
            %heat_map.GridVisible = 'off';
            %heat_map.ColorbarVisible = 'off';
            %heat_map.FontColor = 'none';
            %saveas(heat_map, filename);
            %figure
            %roi = imresize(isnan(cfod_map(:,:,5)), [3000, 3000], 'nearest');
            %imshow(current_patch);
            %hold on
            %handle = imagesc(imresize(cfod_map(:,:,5), [3000, 3000], 'nearest'), [1.5 2.5]);
            %set(handle, 'AlphaData', 0.5*(1-double(roi)));
            %colorbar
        end
    end
end