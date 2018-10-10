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
#import seaborn as sns
from matplotlib import cm
import matplotlib


fg_classified = np.zeros([72], dtype={'names':('name', 'fibers'), 'formats':('U14', 'object')})
name = []
fibers = []
fiber_count = []
#colors = sns.color_palette("hls", 72)
norm = matplotlib.colors.Normalize(vmin=1, vmax=72)
os.mkdir('tracts')


tractsfile = []

n = 1
#for file in glob.glob("TOM_trackings" + "/*.trk"):
for file in glob.glob("tractseg_output/TOM_trackings" + "/*.trk"):
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
        jsonfibers[i] = [jsonfibers[i][0].tolist()]
    jsonfile = {'name': tractname, 'color': list(cm.jet(norm(n)))[0:3], 'coords': jsonfibers}
    #list(colors[n])
    tractsfile.append({"name": tractname, "color": list(cm.jet(norm(n)))[0:3], "filename": str(n)+'.json'})
    
    with open ('tracts/'+str(n)+'.json', 'w') as outfile:
        json.dump(jsonfile, outfile, separators=(',', ': '), indent=4)
        
    
    n+=1

with open ('tracts/tracts.json', 'w') as outfile:
        json.dump(tractsfile, outfile, separators=(',', ': '), indent=4)

fg_classified['name'] = name

fg_classified['fibers'] = fibers


txtfile = open("output_fibercounts.txt","w") 
txtfile.write("Tracts,FiberCount\n") 
for i in range(len(fiber_count)):
    txtfile.write(str(name[i])+','+str(fiber_count[i])+'\n') 
txtfile.close()

sio.savemat('output.mat', {'fg_classified': fg_classified})
