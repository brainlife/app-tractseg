#!/bin/bash

#cuda/nvidia drivers comes from the host. it needs to be mounted by singularity
#export LD_LIBRARY_PATH=/usr/local/cuda-8.0/lib64:$LD_LIBRARY_PATH
#export LD_LIBRARY_PATH=/usr/lib/nvidia-390:$LD_LIBRARY_PATH
#export LD_LIBRARY_PATH=/usr/lib/nvidia-390/extra:$LD_LIBRARY_PATH

source /etc/fsl/5.0/fsl.sh #enable fsl
export PATH=$PATH:/usr/lib/mrtrix/bin #enable mrtrix
export HOME=/ #so that tractseg uses /.tractseg not ~/.tractseg

#echo "using models"
#ls -la ~/.tractseg

TractSeg -i $(jq -r .dwi config.json) -o .
