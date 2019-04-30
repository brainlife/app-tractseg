#!/usr/bin/env python
"""
Created on Tue Oct  9 09:39:41 2018

@author: lindseykitchell
"""

import nibabel as nb
import glob
import os
import numpy as np
import scipy.io as sio
import json
import subprocess

from matplotlib import cm
from json import encoder

encoder.FLOAT_REPR = lambda o: format(o, '.2f') 

names = np.array([], dtype=object)
fiber_index = []

tractsfile = []

def sortKeyFunc(s):
    return os.path.basename(s)

files = glob.glob("tractseg_output/TOM_trackings" + "/*.tck")
files.sort(key=sortKeyFunc)

print("creating wmc")
for file in files:
    filename=str(len(names))+'.json'

    print("loading "+file)
    tck = nb.streamlines.load(file)
    tractname = os.path.basename(file).split('.tck')[0]  
    count = len(tck.streamlines) #should be 2000 most of the time
    streamlines = np.zeros([count], dtype=object)
    for e in range(count):
        streamlines[e] = np.transpose(tck.streamlines[e]).round(2)
    color=list(cm.nipy_spectral(len(names)))[0:3]

    print("sub-sampling for json")
    if count < 1000:
        max = count
    else:
    	max = 1000
    jsonfibers = np.reshape(streamlines[:max], [max,1]).tolist()
    for i in range(max):
        jsonfibers[i] = [jsonfibers[i][0].tolist()]

    with open ('tracts/'+str(len(names))+'.json', 'w') as outfile:
        jsonfile = {'name': tractname, 'color': color, 'coords': jsonfibers}
        json.dump(jsonfile, outfile)

    splitname = tractname.split('_')
    fullname = splitname[-1].capitalize()+' '+' '.join(splitname[0:-1])  
    tractsfile.append({"name": fullname, "color": color, "filename": filename})
    
    #for classification.mat
    index = np.full((count,), len(names)+1) #matlab is 1-base indexed
    fiber_index = np.append(fiber_index, index)
    names = np.append(names, tractname.strip())

print("creating tck/track.tck")
commands = ["tckedit", "-force"] + files + ["tck/track.tck"]
print(commands)
subprocess.call(commands)

with open ('tracts/tracts.json', 'w') as outfile:
    json.dump(tractsfile, outfile, separators=(',', ': '), indent=4)

print("saving classification.mat")
sio.savemat('classification.mat', { "names": names, "index": fiber_index })
print("all done")


