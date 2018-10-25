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

opts=""
if [ $(jq -r .preprocess config.json) == "true" ]; then
	opts="$opts --preprocess"
fi

ln -sf $(jq -r .dwi config.json) dwi.nii.gz
ln -sf $(jq -r .bvecs config.json) dwi.bvecs
ln -sf $(jq -r .bvals config.json) dwi.bvals

t1=`jq -r '.t1' config.json`
if [ $t1 != "null" ]; then
	mkdir -p tractseg_output
	ln -sf $t1 T1w_acpc_dc_restore_brain.nii.gz

	#for a brief period, I needed to put it here.. maybe not needed now?
	ln -sf ../$t1 tractseg_output/T1w_acpc_dc_restore_brain.nii.gz
fi

#csd_type: csd or csd_msmt_5tt 

if [ $(ls tractseg_output/bundle_segmentations | wc -l) != "72" ]; then
	echo "(1/4) running tract_segmentation"
	TractSeg -i dwi.nii.gz --raw_diffusion_input \
		--csd_type $(jq -r .csd config.json) \
		--output_type tract_segmentation \
		--keep_intermediate_files \
		--postprocess \
		--nr_cpus 8 \
		-o . \
		$opts
fi

##Get segmentations of the regions were the bundles start and end (helpful for filtering fibers that do not run from start until end).
if [ $(ls tractseg_output/endings_segmentations | wc -l) != "144" ]; then
	echo "(2/4) running endings_segmentation"
	TractSeg -i tractseg_output/peaks.nii.gz \
		--output_type endings_segmentation \
		--nr_cpus 8 \
		-o .
fi

#For each bundle create a Tract Orientation Map (Wasserthal et al., Tract orientation mapping for bundle-specific tractography). 
#This gives you one peak per voxel telling you the main orientation of the respective bundle at this voxel. Can be used for 
#bundle-specific tracking (add option --track to generate streamlines). Needs around 22GB of RAM because for each bundle three 
#channels have to be stored (216 channels in total).

if [ $(ls tractseg_output/TOM_trackings/*.tck | wc -l) != "72" ]; then
	echo "(3/4) running TOM --tracking"
	TractSeg -i tractseg_output/peaks.nii.gz \
		--output_type TOM \
		--filter_tracking_by_endpoints \
		--track \
		--tracking_format tck \
		--nr_cpus 8 \
		-o .
fi

if [ ! -f tractseg_output/Tractometry_peaks.csv ]; then
	echo "(4/4) running Tractometry"
	#create tractometry files CSD peaks only
	Tractometry -i tractseg_output/TOM_trackings/ \
		-o tractseg_output/Tractometry_peaks.csv \
		-e tractseg_output/endings_segmentations/ \
		-s tractseg_output/peaks.nii.gz \
		--TOM tractseg_output/TOM \
		--tracking_format tck \
		--peak_length
fi

echo "creating wmc datatype"
mkdir -p tracts
python create_fgclassified.py

echo "all done"
