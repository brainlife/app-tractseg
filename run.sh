#!/bin/bash

#enable fsl
source /etc/fsl/5.0/fsl.sh

#enable mrtrix
export PATH=$PATH:/usr/lib/mrtrix/bin

export HOME=/ #so that it uses /.tractseg

ls -la ~/.tractseg
TractSeg -i $(jq -r .dwi) -o .
