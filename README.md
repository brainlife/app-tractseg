[![Abcdspec-compliant](https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg)](https://github.com/brain-life/abcd-spec)
[![Run on Brainlife.io](https://img.shields.io/badge/Brainlife-bl.app.95-blue.svg)](https://doi.org/10.25663/bl.app.95)

# app-tractseg

Segment 72 white matter tracts. 

Brainlife App for Automatic White Matter Bundle Segmentation using [MIC-DKFZ/TractSeg](https://github.com/MIC-DKFZ/TractSeg). A tool for fast and accurate white matter bundle segmentation from Diffusion MRI. 

[TractSeg](https://doi.org/10.1016/j.neuroimage.2018.07.070) was developed by Jakob Wasserthal from Divison of Medical Image Computing at German Cancer Research Center (DKFZ). It uses pretrained 3D Fully Convolutional Neural Networks (FCNNs) to quickly identify human white matter tracts (bundles).

### Reference
Plese refer to the official repository for more details: [MIC-DKFZ/TractSeg](https://github.com/MIC-DKFZ/TractSeg)

### Authors
- Soichi Hayashi (hayashis@iu.edu)

### Contributors
- Lindsey Kitchell (kitchell@iu.edu)

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

You can run this App online 

* with dwi input [https://doi.org/10.25663/bl.app.95](https://doi.org/10.25663/bl.app.95)

via the "Execute" tab.

Input: \
Input dwi image in .nii format. TractSeg will generate CSD peak from this dwi before running TOM tracking, and Tractography. It should be registered to MNI or ACPC aligned t1w.

Outputs: \
The segmented tracts (72 or less).

### Running locally
1. git clone this repo.
2. Inside the cloned directory, create `config.json` with something like the following content with paths to your input files:
```
{
  "dwi":    "./dwi/dwi.nii.gz",
   "bvals":    "./dwi/dwi.bvals",
   "bvecs":    "./dwi/dwi.bvecs"
}
```
3. Launch the App by executing `main`.
```
./main
```

### Output
The App will generate four outputs:
* a whole brain tractogram in .tck format, which includes all the segmented tracts (72 or less);
* the segmented tracts in the White Matter Classification (WMC) format;
* a list of nifti volumes for each tract segments, containing the tract masks;
* a list of nifti volumes for each tract segments, containing the ending masks.

#### Dependencies
This App only requires [singularity](https://sylabs.io/singularity/) to run.

#### MIT Copyright (c) 2020 brainlife.io The University of Texas at Austin and Indiana University, German Cancer Research Center (DKFZ), Division of Medical Image Computing (MIC). 
