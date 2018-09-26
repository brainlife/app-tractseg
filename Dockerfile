FROM nvidia/cuda:9.0-cudnn7-runtime-ubuntu16.04

MAINTAINER Soichi Hayashis <hayashis@iu.edu>

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y git g++ python python-numpy libeigen3-dev zlib1g-dev libqt4-opengl-dev libgl1-mesa-dev libfftw3-dev libtiff5-dev fsl python-pip jq strace

RUN pip install --upgrade pip

## install and compile mrtrix3
RUN git clone https://github.com/MRtrix3/mrtrix3.git
RUN cd mrtrix3 && git fetch --tags && git checkout tags/3.0_RC3 && ./configure && ./build
ENV PATH=$PATH:/mrtrix3/bin

#install pytorch
RUN pip install torch torchvision

#install batchgenerator/tractseg
RUN pip install https://github.com/MIC-DKFZ/batchgenerators/archive/master.zip && pip install https://github.com/MIC-DKFZ/TractSeg/archive/v1.5.zip

#make it work under singularity 
RUN ldconfig && mkdir -p /N/u /N/home /N/dc2 /N/soft

#https://wiki.ubuntu.com/DashAsBinSh 
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

#download tractseg models and mni template?
RUN mkdir -p /.tractseg \
    && mkdir -p /code \
    && curl -SL -o /.tractseg/pretrained_weights_tract_segmentation_v2.npz https://zenodo.org/record/1410884/files/best_weights_ep274.npz?download=1 \
    && curl -SL -o /.tractseg/pretrained_weights_tract_segmentation_dropout_v2.npz https://zenodo.org/record/1414130/files/best_weights_ep407.npz?download=1 \
    && curl -SL -o /.tractseg/pretrained_weights_endings_segmentation_v3.npz https://zenodo.org/record/1409670/files/EndingsSeg_best_weights_ep234.npz?download=1 \
    && curl -SL -o /.tractseg/pretrained_weights_peak_regression_v2.npz https://zenodo.org/record/1419198/files/best_weights_ep125.npz?download=1 \
    && curl -SL -o /.tractseg/pretrained_weights_dm_regression_v1.npz https://zenodo.org/record/1409676/files/DmReg_best_weights_ep427.npz?download=1

#install missing examples directory under /usr/local/lib/python2.7/dist-packages
#https://github.com/MIC-DKFZ/TractSeg/issues/9
ADD examples /usr/local/lib/python2.7/dist-packages/examples

#    && curl -SL -o /code/mrtrix3_RC3.tar.gz https://zenodo.org/record/1415322/files/mrtrix3_RC3.tar.gz?download=1

#RUN apt-get install -y gdb
