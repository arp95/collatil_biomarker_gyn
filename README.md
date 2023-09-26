# CollaTIL Biomarker for Gynecologic Malignancies

[![Packagist](https://img.shields.io/packagist/l/doctrine/orm.svg)](LICENSE.md)
---


## Abstract
The role of immune cells in collagen degradation within the tumor microenvironment (TME) is unclear. We introduce CollaTIL, a computational pathology method that quantitatively characterizes the immune-collagen relationship within the TME of gynecologic cancers, including high-grade serous ovarian (HGSOC), cervical squamous cell (CSCC), and endometrial carcinomas. CollaTIL aims to investigate immune modulatory impact on collagen architecture within the TME, aiming to uncover the interplay between the immune system and tumor progression. We observed that increased immune infiltrate is associated with chaotic collagen architecture and higher entropy, while immune sparse TME exhibits ordered collagen and lower entropy. Importantly, CollaTIL-associated features that stratified disease risk were found to be linked with gene signatures corresponding to TCA-Cycle in CSCC, and amino acid metabolism and macrophages in HGSOC.<br>


## Authors
Arpit Aggarwal, Sirvan Khalighi, Anant Madabhushi<br>


## Manuscript file
Please find the required manuscript documents over here (manuscript/Aggarwal_CollaTIL_manuscript.docx, manuscript/Aggarwal_CollaTIL_supplementary.docx)<br>


## Packages Required
The packages required for running this code are Matlab, PyTorch, Numpy, Openslide, PIL, OpenCV, and Matplotlib.<br>


## Pipeline for CollaTIL biomarker
The main steps involved in the CollaTIL biomarker are as follows:
1. Preprocessing steps (Extracting patches, Epithelium/Stroma segmentation, Nuclei segmentation)
2. Extracting collagen features
3. Extracting immune features
4. Survival analysis


## Running the code
1. Preprocessing steps<br>
a. Extracting patches - This extracts patches from the whole slide image of size 3000x3000-pixel. Run the python file 'python3 code/preprocessing/extract_patches.py' (specify the 'input_path' to the location where whole slide images exist and 'output_path' where you want to store the patches)<br><br>

b. Epithelium/Stroma segmentation - To segment the epithelium/stromal regions on the patches extracted above, run the pretrained epithelium/stroma model 'python3 code/preprocessing/epithelium_stroma_segmentation.py'. The model weights file is located at 'code/preprocessing/epi_seg_unet.pth' (specify the 'input_path' to the location where patches are extracted and 'output_path' where you want to store the epi/stroma segmentation masks)<br><br>

c. Nuclei segmentation - To segment the nuclei regions on the patches extracted above, run the pretrained Hovernet model (https://github.com/vqdang/hover_net). We utilized the PanNuke checkpoint model weights over here.<br><br>


2. Extracting collagen features<br>
3. Extracting immune features<br>
4. Survival analysis<br>

Once the features (collagen and immune) are extracted, we trained a survival model for predicting survival outcomes. The survival model used for our work was LASSO Cox Regression Model and the training was done on D0 cohort and validated on (D1-D8) cohorts.<br>
For reference, we have provided the file 'data/data.csv' which lists all the features used for analysis. Run the notebooks 'notebooks/survival_analysis_D1.ipynb', 'notebooks/survival_analysis_D2.ipynb', 'notebooks/survival_analysis_D3.ipynb', 'notebooks/survival_analysis_D4.ipynb', 'notebooks/survival_analysis_D5_D6_D7.ipynb', and 'notebooks/survival_analysis_D8.ipynb' for validation on D1-D8 cohorts.