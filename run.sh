#!/bin/bash

#enable fsl
source /etc/fsl/5.0/fsl.sh

#enable mrtrix
export PATH=$PATH:/usr/lib/mrtrix/bin

export HOME=/ #so that it uses /.tractseg
echo "using models"
ls -la ~/.tractseg

dwi=$(jq -r .dwi config.json)
echo "running tractseg on $dwi"
TractSeg -i $dwi -o .
