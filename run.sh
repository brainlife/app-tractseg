#!/bin/bash

set -e
set -x

#cuda/nvidia drivers comes from the host. it needs to be mounted by singularity
export LD_LIBRARY_PATH=/usr/local/cuda-8.0/lib64:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/usr/lib/nvidia-410:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=`pwd`/nvidia-410:$LD_LIBRARY_PATH

source /etc/fsl/5.0/fsl.sh #enable fsl (fsl6 still uses /etc/fsl/5.0.. for some reason)
export PATH=$PATH:/usr/lib/mrtrix/bin #enable mrtrix
export HOME=/ #so that tractseg uses /.tractseg not ~/.tractseg to look for prestaged models

rm -rf tractseg_output
rm -rf tracts

opts=""
if [ $(jq -r .preprocess config.json) == "true" ]; then
	opts="$opts --preprocess"
fi

ln -sf $(jq -r .dwi config.json) dwi.nii.gz
ln -sf $(jq -r .bvecs config.json) dwi.bvecs
ln -sf $(jq -r .bvals config.json) dwi.bvals

t1=`jq -r '.t1' config.json`
[ $t1 != "null" ] && ln -sf $t1 T1w_acpc_dc_restore_brain.nii.gz

#csd or csd_msmt_5tt 
TractSeg -i dwi.nii.gz --raw_diffusion_input \
	--csd_type $(jq -r .csd config.json) \
	--output_type tract_segmentation \
	--keep_intermediate_files \
	--postprocess \
	-o . \
	$opts

echo "after tract_segmentation"
ls tractseg_output

#Get segmentations of the regions were the bundles start and end (helpful for filtering fibers that do not run from start until end).
TractSeg -i tractseg_output/peaks.nii.gz \
	--output_type endings_segmentation \
	-o .

echo "after ending_segmentation"
ls tractseg_output

#For each bundle create a Tract Orientation Map (Wasserthal et al., Tract orientation mapping for bundle-specific tractography). 
#This gives you one peak per voxel telling you the main orientation of the respective bundle at this voxel. Can be used for 
#bundle-specific tracking (add option --track to generate streamlines). Needs around 22GB of RAM because for each bundle three 
#channels have to be stored (216 channels in total).
TractSeg -i tractseg_output/peaks.nii.gz \
	--output_type TOM \
	--filter_tracking_by_endpoints \
	--track \
	-o .

echo "after TOM"
ls tractseg_output

#create tractometry files CSD peaks only
Tractometry -i tractseg_output/TOM_trackings/ \
	-o tractseg_output/Tractometry_peaks.csv \
	-e tractseg_output/endings_segmentations/ \
	-s tractseg_output/peaks.nii.gz \
	--TOM tractseg_output/TOM \
	--peak_length

echo "after tractometry"
ls tractseg_output

#create wmc datatype
mkdir -p tracts
python create_fgclassified.py

