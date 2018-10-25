#FROM nvidia/cuda:9.0-cudnn7-runtime-ubuntu16.04
#FROM ubuntu:16.04
#FROM neurodebian:nd16.04-non-free
FROM neurodebian:stretch-non-free

MAINTAINER Soichi Hayashis <hayashis@iu.edu>

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y git g++ python python-numpy libeigen3-dev zlib1g-dev libqt4-opengl-dev libgl1-mesa-dev libfftw3-dev libtiff5-dev fsl-complete python-pip jq strace curl vim

RUN pip install --upgrade pip

## install and compile mrtrix3
RUN git clone https://github.com/MRtrix3/mrtrix3.git
RUN cd mrtrix3 && git fetch --tags && git checkout tags/3.0_RC3 && ./configure && ./build
ENV PATH=$PATH:/mrtrix3/bin

RUN pip install seaborn

#install pytorch
RUN pip install torch torchvision

#RUN mkdir /.tractseg

#install batchgenerator/tractseg
RUN pip install https://github.com/MIC-DKFZ/batchgenerators/archive/master.zip && pip install https://github.com/MIC-DKFZ/TractSeg/archive/v1.7.1.zip
#RUN pip install https://github.com/MIC-DKFZ/batchgenerators/archive/master.zip && pip install https://github.com/MIC-DKFZ/TractSeg/archive/master.zip #10-24-2018

RUN HOME=/ download_all_pretrained_weights

#make it work under singularity 
RUN ldconfig && mkdir -p /N/u /N/home /N/dc2 /N/soft

#https://wiki.ubuntu.com/DashAsBinSh 
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

#apply local patch
#COPY patch/Tractometry /usr/local/bin
#COPY patch/Mrtrix.py /usr/local/lib/python2.7/dist-packages/tractseg/libs

#to simplify fibers.. to slow!
#RUN pip install simplification

