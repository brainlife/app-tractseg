#!/bin/bash

set -e

#cuda/nvidia drivers comes from the host. it needs to be mounted by singularity
export LD_LIBRARY_PATH=/usr/local/cuda-8.0/lib64:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/usr/lib/nvidia-410:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=`pwd`/nvidia-410:$LD_LIBRARY_PATH

source /etc/fsl/5.0/fsl.sh #enable fsl
export PATH=$PATH:/usr/lib/mrtrix/bin #enable mrtrix
export HOME=/ #so that tractseg uses /.tractseg not ~/.tractseg

opts=""
if [ $(jq -r .preprocess config.json) == "true" ]; then
	opts="$preprocess --preprocess"
fi
TractSeg -i $(jq -r .dwi config.json) -o . $opts

#split mask into individual files to be consistent with neuro/mask/tracts datatype
rm -rf masks
mkdir -p masks
(
	cd masks
	fslsplit ../tractseg_output/bundle_segmentations.nii.gz

	#load tractnames.txt (massage some characters) - from TractSeg README
	#names=($(cat ../tractnames.txt | tr -d '() '))
	names=($(cat ../tractnames.txt))
	
	#rename each volume to the tractseg names (postfix by _Vol.nii.gz)
	for i in $(seq 0 71)
	do
		mv $(printf "vol%04d.nii.gz" $i) ${names[$i]}_Vol.nii.gz
	done

	#TODO - what about colors.json?
)

