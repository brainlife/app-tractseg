FROM neurodebian:stretch-non-free

MAINTAINER Soichi Hayashis <hayashis@iu.edu>

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y git g++ python3 libeigen3-dev zlib1g-dev libqt4-opengl-dev libgl1-mesa-dev libfftw3-dev libtiff5-dev fsl-complete python3-pip jq strace curl vim python3-tk

#libgomp1 seems to comes with pytorch so I don't need it

#RUN pip3 install --upgrade pip

## install and compile mrtrix3
RUN git clone https://github.com/MRtrix3/mrtrix3.git
RUN cd mrtrix3 && git fetch --tags && git checkout tags/3.0.0 && ./configure && ./build
ENV PATH=$PATH:/mrtrix3/bin

RUN pip3 install seaborn numpy
RUN pip3 install torch torchvision

#install batchgenerator/tractseg
#RUN pip install https://github.com/MIC-DKFZ/batchgenerators/archive/master.zip && pip install https://github.com/MIC-DKFZ/TractSeg/archive/v1.7.1.zip
RUN pip3 install https://github.com/MIC-DKFZ/batchgenerators/archive/master.zip && pip3 install https://github.com/MIC-DKFZ/TractSeg/archive/v2.1.1.zip

RUN HOME=/ download_all_pretrained_weights

#make it work under singularity 
RUN ldconfig && mkdir -p /N/u /N/home /N/dc2 /N/soft

#https://wiki.ubuntu.com/DashAsBinSh 
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

