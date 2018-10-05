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

#opts="--keep_intermediate_files"
opts=""
if [ $(jq -r .preprocess config.json) == "true" ]; then
	opts="$preprocess --preprocess"
fi
TractSeg --raw_diffusion_input -i $(jq -r .dwi config.json) --output_type tract_segmentation -o . $opts

#ln -s tractseg_output/bundle_segmentations masks

#split mask into individual files to be consistent with neuro/mask/tracts datatype
#rm -rf masks
#mkdir -p masks
#(
#	cd masks
#	fslsplit ../tractseg_output/bundle_segmentations.nii.gz
#
#	#load tractnames.txt (massage some characters) - from TractSeg README
#	#names=($(cat ../tractnames.txt | tr -d '() '))
#	names=($(cat ../tractnames.txt))
#	
#	#rename each volume to the tractseg names (postfix by _Vol.nii.gz)
#	for i in $(seq 0 71)
#	do
#		mv $(printf "vol%04d.nii.gz" $i) ${names[$i]}_Vol.nii.gz
#	done
#
#	#TODO - what about colors.json?
#)

##--track steps TODO..

#Get segmentations of the regions were the bundles start and end (helpful for filtering fibers that do not run from start until end).
TractSeg -i tractseg_output/peaks.nii.gz -o . --output_type endings_segmentation

#For each bundle create a Tract Orientation Map (Wasserthal et al., Tract orientation mapping for bundle-specific tractography). 
#This gives you one peak per voxel telling you the main orientation of the respective bundle at this voxel. Can be used for 
#bundle-specific tracking (add option --track to generate streamlines). Needs around 22GB of RAM because for each bundle three 
#channels have to be stored (216 channels in total).
TractSeg -i tractseg_output/peaks.nii.gz -o . --output_type TOM --track --filter_tracking_by_endpoints 
