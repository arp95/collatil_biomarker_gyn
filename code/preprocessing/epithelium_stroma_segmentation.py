"""
Original Author: Cheng Lu
Modified By: Arpit Aggarwal
Description of the file: Epi/Stroma segmentation. Updated script for my use case.
"""


# header files needed
from unet import *
from glob import glob
from PIL import Image
import numpy as np
import cv2
import torch
import torch.nn as nn
from torchvision import transforms
import sys
import os
from matplotlib import cm
from torch.utils.data import DataLoader


# parameters
model_path = "code/preprocessing/epi_seg_unet.pth"

# CHANGE THIS
input_path = ""

# CHANGE THIS
output_path = ""

image_size = 3000
input_image_size = 750


# load model
device = 'cpu'
net = torch.load(model_path, map_location=device)
net.eval()

# function to return epi/stroma mask for a given patch
def get_patch_epithelium_stroma_mask(input_path):
    # read image and get original patch dimensions
    patch = cv2.imread(input_path)
    patch = cv2.resize(patch, (input_image_size, input_image_size))
    np_original_patch = np.array(patch).astype(np.uint8)
    h = int(np_original_patch.shape[0])
    w = int(np_original_patch.shape[1])

    # get output mask
    np_patch = np.array(patch).astype(np.uint8)
    output_patch_mask = np.zeros((h, w)).astype(np.uint8)
    
    for index1 in range(0, h, input_image_size):
        for index2 in range(0, w, input_image_size):
            np_patch_part = np_patch[index1:index1+ input_image_size, index2:index2+ input_image_size]
            h_part = int(np_patch_part.shape[0])
            w_part = int(np_patch_part.shape[1])

            np_patch_part = np_patch_part.transpose((2, 0, 1))
            np_patch_part = np_patch_part / 255
            tensor_patch = torch.from_numpy(np_patch_part)
            x = tensor_patch.unsqueeze(0)
            x = x.to(device, dtype=torch.float32)
            output = net(x)
            output = torch.sigmoid(output)
            pred = output.detach().squeeze().cpu().numpy()
            mask_pred = (pred>.8).astype(np.uint8)
            pil_mask_pred = Image.fromarray(mask_pred*255)
            np_mask_pred = (np.array(pil_mask_pred)/255).astype(np.uint8)

            # update output
            output_patch_mask[index1:index1+h_part, index2:index2+w_part] = np_mask_pred
    return output_patch_mask


# function to save epi/stroma mask for a given patch
def save_patch_epithelium_stroma_mask(patch, output_path):
    h = patch.shape[0]
    w = patch.shape[1]
    image = np.array(patch)
    image_inv = cv2.threshold(image, 0, 255, cv2.THRESH_BINARY_INV + cv2.THRESH_OTSU)[1]

    # filter using contour area and remove small noise
    cnts = cv2.findContours(image_inv, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
    cnts = cnts[0] if len(cnts) == 2 else cnts[1]
    for c in cnts:
        area = cv2.contourArea(c)
        if area < 100:
            cv2.drawContours(image_inv, [c], -1, (0, 0, 0), -1)

    # filter using contour area and remove small noise
    output_mask = 255 - image_inv
    cnts = cv2.findContours(output_mask, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
    cnts = cnts[0] if len(cnts) == 2 else cnts[1]
    for c in cnts:
        area = cv2.contourArea(c)
        if area < 100:
            cv2.drawContours(output_mask, [c], -1, (0, 0, 0), -1)

    # fill the holes
    #for index in range(0, 3):
    #    final_mask = cv2.dilate(output_mask.copy(), None, iterations=index+1)
    patch = Image.fromarray(output_mask).resize((image_size, image_size), Image.BICUBIC)
    patch.save(output_path)


# run code
if __name__ == '__main__':
    patches = glob(input_path + "*")
    for patch in patches:
        filename = patch.split("/")[-1]
        print(filename)
        output_mask = get_patch_epithelium_stroma_mask(patch)
        save_patch_epithelium_stroma_mask(output_mask, output_path + filename)
    print("Done!")