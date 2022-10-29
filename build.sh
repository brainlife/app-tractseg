#!/bin/bash
set -e

name=brainlife/tractseg
#tag=2.1.1
tag=master
  
docker build -t $name --build-arg tag=$tag .
docker tag $name $name:$tag
docker push $name #for latest
docker push $name:$tag

