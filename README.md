<p align="center">
  <img src="logo.png" alt="TractSeg" width="240">
</p>

<h1 align="center">TractSeg</h1>

<p align="center">
  Masks, ending masks, bundle-specific tractograms and tractometry of 72 white matter tracts from diffusion MRI (or precomputed CSD peaks), segmented with TractSeg.
</p>

<p align="center">
  <a href="https://github.com/brainlife/abcd-spec"><img src="https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg" alt="ABCD Spec v1.1"></a>
  <a href="https://doi.org/10.25663/brainlife.app.684"><img src="https://img.shields.io/badge/Brainlife-brainlife.app.684-blue.svg" alt="Run on brainlife.io"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-lightgrey.svg" alt="MIT license"></a>
</p>

## At a glance

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

> **Segments 72 white matter bundles from precomputed CSD peaks with TractSeg 2.7 and outputs bundle masks, ending masks, bundle-specific tractograms and tractometry.**

Runs TractSeg directly on a peaks image (skipping the CSD step): bundle segmentation, endings segmentation, TOM tracking and Tractometry, converted into brainlife tck, wmc and tractmasks datatypes. Use it when MRtrix3 CSD peaks already exist, for example from another App. The peaks must be in the orientation expected by TractSeg (HCP/MNI-like). Runs on a GPU.

| | |
|---|---|
| **Inputs** | `neuro/peaks` |
| **Outputs** | `neuro/track/tck` · `neuro/wmc` · `neuro/tractmasks` ×2 · `neuro/tractseg` · `neuro/tractmeasures` |
| **Container** | `brainlife/tractseg:2.7` |
| **Resources** | 16 CPUs · 4 h walltime · GPU |
| **Run it** | [doi.org/10.25663/brainlife.app.684](https://doi.org/10.25663/brainlife.app.684) |

#### Inputs

| Input | Datatype | Required | Description |
|---|---|---|---|
| `peaks` | `neuro/peaks` | yes | CSD peaks. Same orientation as HCP (MNI) data, as required by TractSeg. |

#### Outputs

| Output | Datatype | Description |
|---|---|---|
| `tck` | `neuro/track/tck` | All TractSeg bundle-specific (TOM) tractograms merged into a single track.tck. |
| `wmc` | `neuro/wmc` | White matter classification assigning streamlines to the TractSeg bundles, with bundle surfaces for visualisation. |
| `output` | `neuro/tractmasks` | Binary segmentation masks of each white matter bundle (bundle_segmentations). |
| `endingmasks` | `neuro/tractmasks` | Binary masks of the start and end regions of each bundle (endings_segmentations). |
| `tractseg_output` | `neuro/tractseg` | The full TractSeg output directory (peaks, segmentations, TOM, trackings, tractometry). |
| `tractseg_tractometry` | `neuro/tractmeasures` | Tractometry_peaks.csv |

<details>
<summary><b>Parameters</b> (3)</summary>

| Parameter | Type | Default | Description |
|---|---|---|---|
| `nr_fibers` | number | `2000` | Number of fibers to create for each bundle (default: 2000). [non-default options available for App version >= 2.2] |
| `bundles` | string |  | Comma separated list (without spaces) of bundles you want to track. Leave empty if you want to track all (default). For the list of possible bundles, please refer to https://github.com/MIC-DKFZ/TractSeg. [non-default options available for App version >= 2.2] |
| `tractometry_input` | enum | `peak_length` | For tractometry, the peak length along the tracts will be analyzed. If you want to run tractometry on either FA, MD, RD, or AD, you need to have the tensor as input, and you can run the App XXX (work in progress). Options: `peak_length`. |

</details>

<!-- brainlife-app:end -->

## Versions on brainlife.io

Each version is a separate App on brainlife.io, built from a branch of this repository. Only App versions 2.2 and later are maintained.

| Version | TractSeg | Branch | Run it | Status |
|---|---|---|---|---|
| TractSeg from peaks | 2.7 | [`2.7`](https://github.com/brainlife/app-tractseg/tree/2.7) | [doi:10.25663/brainlife.app.684](https://doi.org/10.25663/brainlife.app.684) | current |
| TractSeg (from DWI) | 2.7 | [`2.7`](https://github.com/brainlife/app-tractseg/tree/2.7) | [doi:10.25663/brainlife.app.186](https://doi.org/10.25663/brainlife.app.186) | available |
| TractSeg | 1.7.1 | [`1.7.3`](https://github.com/brainlife/app-tractseg/tree/1.7.3) | [doi:10.25663/bl.app.95](https://doi.org/10.25663/bl.app.95) | deprecated |

Both maintained Apps run the same code: "TractSeg from peaks" starts from a `neuro/peaks` dataset, "TractSeg" computes the CSD peaks from the DWI first.

## About TractSeg

[TractSeg](https://github.com/MIC-DKFZ/TractSeg) is a tool for fast and accurate white matter bundle segmentation from diffusion MRI, developed by Jakob Wasserthal at the Division of Medical Image Computing of the German Cancer Research Center (DKFZ). It uses pretrained 3D fully convolutional neural networks to identify human white matter tracts. See the official repository for details, including the list of bundles.

## Running the App

### On brainlife.io

Open [TractSeg from peaks](https://doi.org/10.25663/brainlife.app.684) and choose a CSD peaks dataset, or open [TractSeg](https://doi.org/10.25663/brainlife.app.186) and choose a DWI dataset; set the options and press **Execute**. The App runs on a GPU and archives a tractogram, a white matter classification, bundle and ending masks, the full TractSeg output and the tractometry table to your project.

- **Orientation**: the DWI (or peaks) must have the same orientation as the Human Connectome Project data (MNI space): LEFT must be on the same side as LEFT in the HCP data. The brain need not be perfectly aligned to MNI.
- **`csd`** (DWI App only): `csd` (standard CSD, default), `csd_msmt` (multi-shell data required) or `csd_msmt_5tt` (multi-shell data and a T1w image registered to the DWI required).
- **`nr_fibers`**: number of streamlines to create for each bundle (default 2000).
- **`bundles`**: comma-separated list (no spaces) of bundles to track; leave empty to track all.
- **`tractometry_input`**: tractometry is run on the peak length along each tract (`peak_length`).

### Locally

You need [Singularity/Apptainer](https://apptainer.org/), [`jq`](https://jqlang.github.io/jq/) and an NVIDIA GPU (`main` runs `brainlife/tractseg:2.7` with `--nv`). `main` also uses `brainlife/dipy:1.1.1`, `brainlife/pythonvtk:1.1` and `brainlife/mrtrix3:3.0.0`.

1. Clone this repository and check out the maintained version (`git checkout 2.7`).
2. Create `config.json` with the paths to your inputs and the options you want:

   ```json
   {
       "dwi": "/input/dwi/dwi.nii.gz",
       "bvecs": "/input/dwi/dwi.bvecs",
       "bvals": "/input/dwi/dwi.bvals",
       "preprocess": false,
       "csd": "csd",
       "nr_fibers": 2000,
       "bundles": "",
       "tractometry_input": "peak_length"
   }
   ```

   To start from peaks, replace the DWI keys with `"peaks": "/input/peaks/peaks.nii.gz"`. For `csd_msmt_5tt`, add `"t1": "/input/t1/t1.nii.gz"`.

3. Run the App:

   ```bash
   ./main
   ```

## Outputs

```text
tck/track.tck                     all bundle-specific (TOM) tractograms merged into one tractogram
wmc/                              white matter classification of the TractSeg bundles, with tracts/ and surfaces/
output/masks/                     binary mask of each bundle (bundle_segmentations)
endingmasks/masks/                binary masks of the start and end regions of each bundle (endings_segmentations)
tractseg_output/                  full TractSeg output: peaks, segmentations, TOM, TOM_trackings, Tractometry_peaks.csv
tractseg_tractometry/tractmeasures.csv   tractometry table (Tractometry_peaks.csv)
```

## Troubleshooting

- **`Error: csd_msmt_5tt requires a T1w image.`**: provide the optional T1w input (registered to the DWI) or choose `csd` or `csd_msmt`.
- **`Error: csd_msmt_5tt doesn't work with --preprocess.`**: disable `preprocess` when using `csd_msmt_5tt`. The `preprocess` option is currently disabled on brainlife.io because it produces `peaks.nii.gz` of the wrong size for the later steps; align the data to MNI orientation beforehand instead.
- **Missing or misplaced tracts**: check that the input has the HCP/MNI orientation described above.

## Citing

> [!TIP]
> If you use this App in your work, please cite the App, the software it builds on and brainlife.io (below). GitHub's **Cite this repository** button gives the App citation in APA and BibTeX.

- Wasserthal J, Neher P, Maier-Hein KH. TractSeg: fast and accurate white matter tract segmentation. *NeuroImage* 183:239–253 (2018). [doi:10.1016/j.neuroimage.2018.07.070](https://doi.org/10.1016/j.neuroimage.2018.07.070)
- TractSeg from peaks. brainlife.io App. [doi:10.25663/brainlife.app.684](https://doi.org/10.25663/brainlife.app.684)
- Jenkinson et al. FSL. *NeuroImage* 62:782-790 (2012). [doi:10.1016/j.neuroimage.2011.09.015](https://doi.org/10.1016/j.neuroimage.2011.09.015)
- Tournier et al. MRtrix3: A fast, flexible and open software framework for medical image processing and visualisation. *NeuroImage* 202:116137 (2019). [doi:10.1016/j.neuroimage.2019.116137](https://doi.org/10.1016/j.neuroimage.2019.116137)
- Garyfallidis et al. Dipy, a library for the analysis of diffusion MRI data. *Frontiers in Neuroinformatics* 8 (2014). [doi:10.3389/fninf.2014.00008](https://doi.org/10.3389/fninf.2014.00008)
- Hayashi S, Caron BA, Heinsfeld AS, et al. brainlife.io: a decentralized and open-source cloud platform to support neuroscience research. *Nature Methods* 21:809–813 (2024). [doi:10.1038/s41592-024-02237-2](https://doi.org/10.1038/s41592-024-02237-2)
- Avesani P, McPherson B, Hayashi S, et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. *Scientific Data* 6:69 (2019). [doi:10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)

## Authors

- Soichi Hayashi
- Franco Pestilli (project director)

**Contributors:** Jakob Wasserthal, Lindsey Kitchell, Giulia Bertò, Brad Caron

## Funding

[![Wellcome-226486/Z/22/Z](https://img.shields.io/badge/Wellcome-226486%2FZ%2F22%2FZ-purple.svg)](https://wellcome.org/)
[![NIH-NINDS-U24NS140384](https://img.shields.io/badge/NIH_NINDS-U24NS140384-green.svg)](https://reporter.nih.gov/project-details/11261037)
[![NIH-NINDS-UM1NS132207](https://img.shields.io/badge/NIH_NINDS-UM1NS132207-green.svg)](https://reporter.nih.gov/project-details/11411328)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://reporter.nih.gov/project-details/10262925)
[![NIH-NIBIB-R01EB030896](https://img.shields.io/badge/NIH_NIBIB-R01EB030896-green.svg)](https://reporter.nih.gov/project-details/10428625)
[![NIH-NIMH-R01MH126699](https://img.shields.io/badge/NIH_NIMH-R01MH126699-green.svg)](https://reporter.nih.gov/project-details/10460628)
[![NIH-NIDCD-R01DC020088](https://img.shields.io/badge/NIH_NIDCD-R01DC020088-green.svg)](https://reporter.nih.gov/project-details/11140284)
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-2203524](https://img.shields.io/badge/NSF_BCS-2203524-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2203524)
[![NSF-IIS-1636893](https://img.shields.io/badge/NSF_IIS-1636893-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-OAC-2148729](https://img.shields.io/badge/NSF_OAC-2148729-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148729)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NSF-IIS-2148700](https://img.shields.io/badge/NSF_IIS-2148700-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148700)
[![NSF-OAC-1916518](https://img.shields.io/badge/NSF_OAC-1916518-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1916518)

<sub>brainlife.io is publicly funded, and acknowledging that support helps keep it running. This App was developed with support from Wellcome, the U.S. National Institutes of Health (including the BRAIN Initiative BRAIN CONNECTS program: The Axonal Projectome EXchange, U24NS140384, and the Center for Mesoscale Connectomics, UM1NS132207) and the U.S. National Science Foundation.</sub>

## License

[MIT](LICENSE). Copyright brainlife.io, The University of Texas at Austin and Indiana University, German Cancer Research Center (DKFZ), Division of Medical Image Computing (MIC). TractSeg itself is distributed under its own [license](https://github.com/MIC-DKFZ/TractSeg).
