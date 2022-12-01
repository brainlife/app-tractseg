[![Abcdspec-compliant](https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg)](https://github.com/brain-life/abcd-spec)
[![Run on Brainlife.io](https://img.shields.io/badge/Brainlife-bl.app.95-blue.svg)](https://doi.org/10.25663/bl.app.95)

# app-tractseg

[Warning: only App versions >= 2.2 are currently maintained.]

Segment 72 white matter tracts. 

Brainlife App for Automatic White Matter Bundle Segmentation using [MIC-DKFZ/TractSeg](https://github.com/MIC-DKFZ/TractSeg). A tool for fast and accurate white matter bundle segmentation from Diffusion MRI. 

[TractSeg](https://doi.org/10.1016/j.neuroimage.2018.07.070) was developed by Jakob Wasserthal from Divison of Medical Image Computing at German Cancer Research Center (DKFZ). It uses pretrained 3D Fully Convolutional Neural Networks (FCNNs) to quickly identify human white matter tracts (bundles).

### Reference
Plese refer to the official repository for more details: [MIC-DKFZ/TractSeg](https://github.com/MIC-DKFZ/TractSeg).

### Authors
- Soichi Hayashi (hayashis@iu.edu)

### Contributors
- Jakob Wasserthal (j.wasserthal@dkfz.de)
- Lindsey Kitchell (kitchell@iu.edu)
- Giulia Berto

### Project director
- Franco Pestilli (franpest@indiana.edu)

### Funding Acknowledgement
brainlife.io is publicly funded and for the sustainability of the project it is helpful to Acknowledge the use of the platform. We kindly ask that you acknowledge the funding below in your publications and code reusing this code.

[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-1636893](https://img.shields.io/badge/NSF_BCS-1636893-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-ACI-1916518](https://img.shields.io/badge/NSF_ACI-1916518-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1916518)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://grantome.com/grant/NIH/R01-EB029272-01)

### Citation
We kindly ask that you cite the following articles when publishing papers and code using this code: 
1. Wasserthal, J., Neher, P., & Maier-Hein, K. H. (2018). TractSeg-Fast and accurate white matter tract segmentation. NeuroImage, 183, 239-253. [https://doi.org/10.1016/j.neuroimage.2018.07.070](https://doi.org/10.1016/j.neuroimage.2018.07.070)
2. Avesani, P., McPherson, B., Hayashi, S. et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. Sci Data 6, 69 (2019). [https://doi.org/10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)

## Running the App 
### On [Brainlife.io](http://brainlife.io/) 
You can submit this App online at https://doi.org/10.25663/brainlife.app.186 via the “Execute” tab.

Input: \
The dwi image in .nii format. TractSeg will generate CSD peaks from this dwi before running TOM tracking, Tractography, and Tractometry. The input dwi image must have the same "orientation" as the Human Connectome Project data (MNI space) (LEFT must be on the same side as LEFT of the HCP data).
Alternatively, a peaks.nii.gz file can be given as input (App "TractSeg - from peaks" https://doi.org/10.25663/brainlife.app.684).

Optional inputs:
- T1w images (registered to the dwi), required for cst_msmt_5tt option.
- (work in progress) tensor image (registered to the dwi), required to run Tractometry on either FA, MD, RD, or AD instead that on the peak length (default).

Output: \
The segmented white matter tracts.

### Running locally
1. git clone this repo.
2. Inside the cloned directory, create `config.json` with something like the following content with paths to your input files:
```
{
"dwi": "testdata/dwi.nii.gz",
"bvecs": "testdata/dwi.bvecs",
"bvals": "testdata/dwi.bvals",
"preprocess": false,
"csd": "csd",
"nr_fibers": 2000,
"bundles": "",
"tractometry_input": "peak_length"
}
```
3. Launch the App by executing `main`.
```
./main
```

### Output
This App will generate four outputs:
* a whole brain tractogram in .tck format, which includes all the segmented tracts (72 or less)
* the segmented tracts in the white matter classification (wmc) format
* a list of nifti volumes for each tract segments, containing the tract masks
* a list of nifti volumes for each tract segments, containing the ending masks
* a Tractseg output directory containing bundle_segmentations, endings_segmentations, Tractometry_peaks.csv, etc..
* a tractmeasures.csv file corresponding to the Tractometry_peaks.csv file

#### Dependencies
This App only requires [singularity](https://sylabs.io/singularity/) to run.

#### MIT Copyright (c) 2020 brainlife.io The University of Texas at Austin and Indiana University, German Cancer Research Center (DKFZ), Division of Medical Image Computing (MIC). 
