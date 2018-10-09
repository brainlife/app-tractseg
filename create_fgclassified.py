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
import seaborn as sns
#import matplotlib.pyplot as plt


fg_classified = np.zeros([72], dtype={'names':('name', 'fibers'), 'formats':('U14', 'object')})
name = []
fibers = []
fiber_count = []
colors = sns.color_palette("hls", 72)
#for file in glob.glob("tractseg_output/TOM_trackings" + "/*.trk"):
n = 1
for file in glob.glob("TOM_trackings" + "/*.trk"):
    trk = nb.streamlines.load(file)
    tractname = os.path.basename(file).split('.trk')[0]  
    name.append(np.array(tractname))
    
    fiber_count.append(len(trk.streamlines))
    streamlines = np.zeros([len(trk.streamlines)], dtype=object)
    for e in range(len(trk.streamlines)):
        streamlines[e] = np.transpose(trk.streamlines[e])
    fibers.append(np.reshape(streamlines, [len(trk.streamlines),1]))
    
    jsonfibers = np.reshape(streamlines, [len(trk.streamlines),1]).tolist()
    for i in range(len(jsonfibers)):
        jsonfibers[i] = jsonfibers[i][0].tolist()
    jsonfile = {'name': tractname, 'color': list(colors[n]), 'coords': jsonfibers}
    with open (str(n)+'.json', 'w') as outfile:
        json.dump(jsonfile, outfile, separators=(',', ': '), indent=4)
    n+=1
    
fg_classified['name'] = name

fg_classified['fibers'] = fibers


txtfile = open("output_fibercounts.txt","w") 
txtfile.write("Tracts,FiberCount\n") 
for i in range(len(fiber_count)):
    txtfile.write(str(name[i])+','+str(fiber_count[i])+'\n') 
txtfile.close()

sio.savemat('output.mat', {'fg_classified': fg_classified})