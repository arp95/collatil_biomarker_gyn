# CollaTIL Biomarker

---


## Abstract
The role of immune cells in collagen degradation within the tumor microenvironment (TME) is unclear. We introduce CollaTIL, a computational pathology method that quantitatively characterizes the immune-collagen relationship within the TME of gynecologic cancers, including high-grade serous ovarian (HGSOC), cervical squamous cell (CSCC), and endometrial carcinomas. CollaTIL aims to investigate immune modulatory impact on collagen architecture within the TME, aiming to uncover the interplay between the immune system and tumor progression. We observed that increased immune infiltrate is associated with chaotic collagen architecture and higher entropy, while immune sparse TME exhibits ordered collagen and lower entropy. Importantly, CollaTIL-associated features that stratified disease risk were found to be linked with gene signatures corresponding to TCA-Cycle in CSCC, and amino acid metabolism and macrophages in HGSOC.<br>


## Authors
Arpit Aggarwal, Sirvan Khalighi, Anant Madabhushi<br>


## Manuscript file
Please find the required manuscript documents over here (manuscript/Aggarwal_CollaTIL_manuscript.docx, manuscript/Aggarwal_CollaTIL_supplementary.docx)<br>


## Packages Required
The packages required for running this code are Matlab, PyTorch, Numpy, Openslide, PIL, OpenCV, Pandas, Sksurv, Sklearn, and Matplotlib.<br>


## Pipeline for CollaTIL biomarker
The main steps involved in the CollaTIL biomarker are as follows:
1. Preprocessing steps (Extracting tiles from H&E-stained Whole Slide Images, Epithelium/Stroma segmentation, Nuclei segmentation)
2. Extracting collagen features
3. Extracting immune features
4. Survival analysis
5. Genomic analysis


## Running the code
1. <b>Preprocessing steps</b><br>
a. <b>Extracting tiles from H&E-stained Whole Slide Images</b> - This extracts tiles from the whole slide image of size 3000x3000-pixel. Run the python file 'python3 code/preprocessing/extract_patches.py' (specify the 'input_path' to the location where whole slide images exist and 'output_path' where you want to store the tiles)<br><br>

<img src="example/patch/TCGA-23-1809_30000_30000.png" width="200" height="200">


b. <b>Epithelium/Stroma segmentation</b> - To segment the epithelium/stromal regions on the tiles extracted above, run the pretrained epithelium/stroma model 'python3 code/preprocessing/epithelium_stroma_segmentation.py'. The model weights file is located at 'code/preprocessing/epi_seg_unet.pth' (specify the 'input_path' to the location where tiles are extracted and 'output_path' where you want to store the epithelium/stroma segmentation masks)<br><br>

<img src="example/epi_stroma_mask/TCGA-23-1809_30000_30000.png" width="200" height="200">


c. <b>Nuclei segmentation</b> - To segment the nuclei regions on the tiles extracted above, run the pretrained Hovernet model (https://github.com/vqdang/hover_net). We utilized the PanNuke checkpoint model weights over here.<br><br>

<img src="example/nuclei_mask/TCGA-23-1809_30000_30000.png" width="200" height="200">


2. <b>Extracting collagen features</b><br>
As described in the manuscript, for extracting the collagen features run the Matlab file (code/collagen/feature_map_for_each_tile.m) that generates the Collagen Fiber Orientation Disorder map for each tile extracted (for different tumor neighborhood sizes, you would need to change this variable 'win_size' as 200, 250, 300, 350, 400, 450, 500, 550, and 600).
(specify the 'patches_dir' to the location where tiles are extracted, 'epi_stroma_masks_dir' where epithelium/stroma segmentation masks are extracted, 'nuclei_masks_dir' where the nuclei segmentation masks are extracted, and 'collagen_masks_dir' where you want to store the feature maps for each tile.)<br><br>
After obtaining the feature maps for each tile and for each tumor neighborhood (create separate folders for each tumor neighborhood), run the Matlab file (code/collagen/patient_level_features_collagen.m) that gives patient-level features (mean, minimum, and maximum) for each patient and for each tumor neighborhood, giving a total of 27 features.
(specify the 'files_dir' to the location patient list is for the cohort, 'feature_maps_dir' where feature maps are extracted after running the Matlab file 'code/collagen/feature_map_for_each_tile.m', 'collagen_masks_dir' where you want to store the patient-level features.)<br><br>

<img src="example/collagen/collagen.png" width="800" height="200">


3. <b>Extracting immune features</b><br>
As described in the manuscript, for extracting the immune features for each tile run the Matlab file (code/immune/feature_for_each_tile.m).
(specify the 'HE_patch_folder' to the location where tiles are extracted, 'ES_folder' where epithelium/stroma segmentation masks are extracted, 'nuc_folder' where the nuclei segmentation masks are extracted, and 'features_store' where you want to store the features for each tile.)<br><br>
After obtaining the immune features for each tile, the patient-level features are obtained by taking the first-order statistics (mean, median, minimum, maximum, range, and variance) for the tiles of the H&E-WSI. As described in the paper (https://jitc.bmj.com/content/10/2/e003833), the top 7 features that were found prognostic by training the LASSO Cox Model on D0 cohort and these were the features that were used in this paper from the immune component of the TME.<br><br>

<img src="example/immune/immune.png" width="800" height="200">


4. <b>Survival analysis</b><br>

    Once the features (collagen and immune) are extracted, we trained a survival model for predicting survival outcomes. The survival model used for our work was LASSO Cox Regression Model and the training was done on D0 cohort and validated on (D1-D8) cohorts.<br>
For reference, we have provided the file 'data/data.csv' which lists all the features from all the cohorts (D1-D8) used for analysis. Run the notebooks 'code/survival_analysis/notebooks/survival_analysis_D1.ipynb', 'code/survival_analysis/notebooks/survival_analysis_D2.ipynb', 'code/survival_analysis/notebooks/survival_analysis_D3.ipynb', 'code/survival_analysis/notebooks/survival_analysis_D4.ipynb', 'code/survival_analysis/notebooks/survival_analysis_D5_D6_D7.ipynb', and 'code/survival_analysis/notebooks/survival_analysis_D8.ipynb' for validation on D1-D8 cohorts.<br><br>

<img src="example/survival_analysis/figure4.png" width="800" height="800">