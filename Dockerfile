FROM nvidia/cuda:9.0-cudnn7-runtime-ubuntu16.04

MAINTAINER Soichi Hayashis <hayashis@iu.edu>

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y git g++ python python-numpy libeigen3-dev zlib1g-dev libqt4-opengl-dev libgl1-mesa-dev libfftw3-dev libtiff5-dev fsl python-pip jq strace

## install and compile mrtrix3
RUN git clone https://github.com/MRtrix3/mrtrix3.git
RUN cd mrtrix3 && git fetch --tags && git checkout tags/3.0_RC3 && ./configure && ./build

#install batchgenerator
RUN pip install https://github.com/MIC-DKFZ/batchgenerators/archive/master.zip

#install pytorch
RUN pip install torch torchvision

#install tractseg
RUN pip install https://github.com/MIC-DKFZ/TractSeg/archive/v1.5.zip

#make it work under singularity 
RUN ldconfig && mkdir -p /N/u /N/home /N/dc2 /N/soft

#https://wiki.ubuntu.com/DashAsBinSh 
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

#enable mrtrix3
ENV PATH=$PATH:/mrtrix3/bin

#download tractseg models
RUN mkdir -p /.tractseg \
    && curl -SL -o /.tractseg/pretrained_weights_tract_segmentation_v1.npz https://www.dropbox.com/s/nygr0j2zgztedh0/TractSeg_best_weights_ep448.npz?dl=1 \
    && curl -SL -o /.tractseg/pretrained_weights_endings_segmentation_v2.npz https://www.dropbox.com/s/l5fa6hhtbv5npvm/EndingsSeg_best_weights_ep176.npz?dl=1 \
    && curl -SL -o /.tractseg/pretrained_weights_peak_regression_v1.npz https://www.dropbox.com/s/ogywkbrj3165v3e/PeakReg_best_weights_ep229.npz?dl=1 \
&& curl -SL -o /.tractseg/pretrained_weights_dm_regression_v1.npz https://www.dropbox.com/s/d82iv95flz8n5a2/DmReg_best_weights_ep427.npz?dl=1

#RUN apt-get install -y gdb
