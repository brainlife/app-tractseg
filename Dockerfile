#FROM nvidia/cuda:9.0-cudnn7-runtime-ubuntu16.04
#FROM ubuntu:16.04
#FROM neurodebian:nd16.04-non-free
FROM neurodebian:stretch-non-free

MAINTAINER Soichi Hayashis <hayashis@iu.edu>

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y git g++ python python-numpy libeigen3-dev zlib1g-dev libqt4-opengl-dev libgl1-mesa-dev libfftw3-dev libtiff5-dev fsl-core python-pip jq strace curl vim

RUN pip install --upgrade pip

## install and compile mrtrix3
RUN git clone https://github.com/MRtrix3/mrtrix3.git
RUN cd mrtrix3 && git fetch --tags && git checkout tags/3.0_RC3 && ./configure && ./build
ENV PATH=$PATH:/mrtrix3/bin

#install pytorch
RUN pip install torch torchvision

RUN mkdir /.tractseg

#download tractseg models and mni template?
RUN curl -SL -o /.tractseg/pretrained_weights_tract_segmentation_v2.npz https://zenodo.org/record/1410884/files/best_weights_ep274.npz?download=1 \
    && curl -SL -o /.tractseg/pretrained_weights_tract_segmentation_dropout_v2.npz https://zenodo.org/record/1414130/files/best_weights_ep407.npz?download=1 \
    && curl -SL -o /.tractseg/pretrained_weights_endings_segmentation_v3.npz https://zenodo.org/record/1409670/files/EndingsSeg_best_weights_ep234.npz?download=1 \
    && curl -SL -o /.tractseg/pretrained_weights_peak_regression_v2.npz https://zenodo.org/record/1419198/files/best_weights_ep125.npz?download=1 \
    && curl -SL -o /.tractseg/pretrained_weights_dm_regression_v1.npz https://zenodo.org/record/1409676/files/DmReg_best_weights_ep427.npz?download=1

#download best weights (for tracking)
RUN curl -SL -o /.tractseg/pretrained_weights_peak_regression_part1_v1.npz https://zenodo.org/record/1434206/files/best_weights_ep226.npz?download=1 \
    && curl -SL -o /.tractseg/pretrained_weights_peak_regression_part2_v1.npz https://zenodo.org/record/1434208/files/best_weights_ep210.npz?download=1 \
    && curl -SL -o /.tractseg/pretrained_weights_peak_regression_part3_v1.npz https://zenodo.org/record/1434210/files/best_weights_ep185.npz?download=1 \
    && curl -SL -o /.tractseg/pretrained_weights_peak_regression_part4_v1.npz https://zenodo.org/record/1434212/files/best_weights_ep174.npz?download=1

#install batchgenerator/tractseg
RUN pip install https://github.com/MIC-DKFZ/batchgenerators/archive/master.zip && pip install https://github.com/MIC-DKFZ/TractSeg/archive/v1.6.zip

#make it work under singularity 
RUN ldconfig && mkdir -p /N/u /N/home /N/dc2 /N/soft

#https://wiki.ubuntu.com/DashAsBinSh 
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

