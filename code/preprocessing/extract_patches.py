"""
Authors: Arpit Aggarwal and Can Koyuncu
Description of the file: Script for extracting patches from WSIs in 40x/20x, ensuring empty regions are ignored.
"""


# header files
import math, sys, time, glob, os
from openslide import open_slide, deepzoom
from PIL import ImageStat, Image
import numpy as np
print("Header files loaded...")


# function for extracting patches
def patch_extraction(wsi_path, output_path, tile_size=3000):
    # read slide
    slide = open_slide(wsi_path)

    # set mask level
    mask_level = 0
    if len(slide.level_downsamples) > 1:
        if slide.level_downsamples[1] == 4:
            mask_level = 1
        else:
            mask_level = 2
    
    # using deepzoom read non-empty regions
    dz = deepzoom.DeepZoomGenerator(slide, tile_size=tile_size, overlap=0, limit_bounds=True)
    mask_tile_size = tile_size*slide.level_downsamples[0] // slide.level_downsamples[mask_level]
    dz_level = dz.level_count-1
    
    # get filename
    filename = wsi_path.split("/")[-1]
    filename = filename.split(".")[0][:-4]
    print(filename)
    
    # read entire slide
    mask = slide.read_region((0, 0), mask_level, slide.level_dimensions[mask_level]).convert("L")
    fn = lambda x : 0 if x > 200 or x < 50 else 1
    mask = mask.point(fn, mode='1')
    
    # loop through each patch of the slide of size=(tile_size, tile_size)
    for i in range(dz.level_tiles[dz_level][0]):
        for j in range(dz.level_tiles[dz_level][1]):
            coord = dz.get_tile_coordinates(dz_level, (i, j))
            if coord[2] != (tile_size, tile_size):
                continue
            else:
                coord = coord[0]
            cenX = (coord[0] + tile_size*slide.level_downsamples[0]//2) // slide.level_downsamples[mask_level]
            cenY = (coord[1] + tile_size*slide.level_downsamples[0]//2) // slide.level_downsamples[mask_level]
            mask_region = mask.crop((cenX-(mask_tile_size//2), cenY-(mask_tile_size//2), cenX+(mask_tile_size//2), cenY+(mask_tile_size//2)))
            if ImageStat.Stat(mask_region).mean[0] > 0.4:
                tile = dz.get_tile(dz_level, (i, j)).convert("RGB")
                tile_output_path = os.path.join(output_path, filename + "_" + str(coord[0]) + '_' + str(coord[1]) + '.png')
                tile.save(tile_output_path)



# command to extract patches
# CHANGE THIS WHERE THE WHOLE SLIDE IMAGES ARE
input_path = ""

# CHANGE THIS TO WHERE PATCHES NEED TO BE STORED
output_path = ""

files = glob.glob(input_path + "*")
print(files)
for file in files:
    print(file)
    patch_extraction(wsi_path=file, output_path=output_path)