#!/bin/bash

set -e

source /etc/fsl/5.0/fsl.sh #enable fsl
export PATH=$PATH:/usr/lib/mrtrix/bin #enable mrtrix
export HOME=/ #so that tractseg uses /.tractseg not ~/.tractseg

TractSeg -i $(jq -r .dwi config.json) -o .

#split mask into individual files to be consistent with neuro/mask/tracts datatype
rm -rf masks
mkdir -p masks
(
	cd masks
	fslsplit ../tractseg_output/bundle_segmentations.nii.gz

	#load tractnames.txt (massage some characters) - from TractSeg README
	names=($(cat ../tractnames.txt | tr -d '() '))
	
	#rename each volume to the tractseg names (postfix by _Vol.nii.gz)
	id=0
	for file in $(ls vol*.nii.gz | sort); do
		mv $file ${names[$id]}_Vol.nii.gz
		let "id = id + 1"
	done

	#TODO - what about colors.json?
)

