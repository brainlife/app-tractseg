#!/usr/bin/env python

import vtk
import sys
import os
import json
import pandas as pd
from matplotlib import cm

if not os.path.exists("surfaces"):
   os.makedirs("surfaces")

index=[]

inputdir="tractseg_output/bundle_segmentations"
for file in os.listdir(inputdir):
    if file[0] == ".":
        continue

    tokens = file.split(".")
    surf_name=tokens[0]
    vtk_filename=surf_name+".vtk"

    #r=100
    #g=100
    #b=0
    color=list(cm.nipy_spectral(len(index)))[0:3]
    #index.append({'filename':vtk_filename, 'name': surf_name, 'color': {'r':r, 'g':g, 'b':b}})
    index.append({'filename':vtk_filename, 'name': surf_name, 'color': color})

    img_path = inputdir+"/"+file

    # import the binary nifti image
    print("loading %s" % img_path)
    reader = vtk.vtkNIFTIImageReader()
    reader.SetFileName(img_path)
    reader.Update()

    print(reader.GetQFormMatrix())
    print(reader.GetSFormMatrix())

    # do marching cubes to create a surface
    surface = vtk.vtkDiscreteMarchingCubes()
    surface.SetInputConnection(reader.GetOutputPort())

    # GenerateValues(number of surfaces, label range start, label range end)
    surface.GenerateValues(1, 1, 1)
    surface.Update()

    smoother = vtk.vtkWindowedSincPolyDataFilter()
    smoother.SetInputConnection(surface.GetOutputPort())
    smoother.SetNumberOfIterations(10)
    smoother.NonManifoldSmoothingOn()
    smoother.NormalizeCoordinatesOn()
    smoother.Update()

    connectivityFilter = vtk.vtkPolyDataConnectivityFilter()
    connectivityFilter.SetInputConnection(smoother.GetOutputPort())
    connectivityFilter.SetExtractionModeToLargestRegion()
    connectivityFilter.Update()

    untransform = vtk.vtkTransform()
    #untransform.SetMatrix(reader.GetQFormMatrix())
    untransform.SetMatrix(reader.GetSFormMatrix())
    untransformFilter=vtk.vtkTransformPolyDataFilter()
    untransformFilter.SetTransform(untransform)
    untransformFilter.SetInputConnection(connectivityFilter.GetOutputPort())
    untransformFilter.Update()

    cleaned = vtk.vtkCleanPolyData()
    cleaned.SetInputConnection(untransformFilter.GetOutputPort())
    cleaned.Update()

    deci = vtk.vtkDecimatePro()
    deci.SetInputConnection(cleaned.GetOutputPort())
    deci.SetTargetReduction(0.5)
    deci.PreserveTopologyOn()

    writer = vtk.vtkPolyDataWriter()
    writer.SetInputConnection(deci.GetOutputPort())
    writer.SetFileName("surfaces/"+vtk_filename)
    writer.Write()

print("writing surfaces/index.json")
with open("surfaces/index.json", "w") as outfile:
    json.dump(index, outfile)

print("all done")

