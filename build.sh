#!/bin/bash
set -e

name=brainlife/tractseg
tag=1.5b
  
docker build -t $name .
docker tag $name $name:$tag
docker push $name #for latest
docker push $name:$tag
