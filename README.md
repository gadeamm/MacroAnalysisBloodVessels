# MacroAnalysisBloodVessels
Macro for Analysis of the blood vessels implemented for [ImageJ](http://imagej.nih.gov/ij/) or [Fiji](https://fiji.sc/)

This macro has been developed for the analysis of the blood vessels density for an assay performed by Andrea Luengas-Martinez (Centre for Dermatology Research, The University of Manchester). 

Luengas-Martinez A, Hardman-Smart J, Rutkowski D, Purba TS, Paus R, Young HS. Vascular Endothelial Growth Factor Blockade Induces Dermal Endothelial Cell Apoptosis in a Clinically Relevant Skin Organ Culture Model. Skin Pharmacol Physiol. 2020;33(3):110-118. doi: [10.1159/000508344](https://www.karger.com/Article/FullText/508344). Epub 2020 Jun 22. PMID: 32570235.

## Description

Sections stained with CD31 (red)  and LYVE-1 (green) monoclonal antibodies were used to study the blood vasculature and morphometric analysis was performed using this macro for ImageJ (Fiji) to analyse the average dermal blood vascular surface area. 

The macro automates a series of ImageJ commands used to measure the percentage of the dermis area occupied by blood vessels (CD31+LYVE-1-).

The macro allows to perform a semi-automated analysis, where the area of study needs to be determined and the threshold for the blood vessel segmentation has to be adapted. It measures the red area and the green intensity in the red channel previously segmented. When the macro is started, the first step consists of changing pixels to micrometres. 

Then, the region that is going to be analysed i.e., the dermis, is surrounded manually and the part of the image outside the selected area is deleted automatically. In the next step the channels are divided and the blue channel (DAPI) is closed. 

The red channel is segmented and two smooth filters are applied to achieve an optimal segmentation. In the next step, the user sets a threshold to determine what should be considered a blood vessel. 

The “MaxEntropy” method was used in this analysis because it gets close to the desired values and provides a good segmentation. The segmented regions are acquired and the regions are shown in the RoiManager. Next, the green channel is opened and it shows the regions in green that overlap with the red channel. 

The area of the red channel as well as the mean and the standard deviation of the intensity of the green channel are measured. 

A table with the results is generated and it is saved in the same folder where the images are located in a folder named “output”. 
The regions of interest with a value of green mean intensity over 100 are excluded from the analysis since they are considered lymphatic vessels. All the dialogue boxes are closed and the macro automatically opens the next image in the folder. 

## Use or Install 
.- Use it, open the ijm-file on ImageJ or Fiji and pressing ctrl+r (or "Run").

.- Install it, save the macro in a "Plugins" subfolder and it will appear in the menu (Plugins > Macro_AnalysisBloodVessels) upon restart of ImageJ/Fiji (for more information click [here](https://imagej.net/Introduction_into_Macro_Programming#Installing_macros)).
