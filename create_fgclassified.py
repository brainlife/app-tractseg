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
from matplotlib import cm
import matplotlib

from json import encoder
encoder.FLOAT_REPR = lambda o: format(o, '.3f') #.3 too aggresive?

fg_classified = np.zeros([72], dtype={'names':('name', 'fibers'), 'formats':('U14', 'object')})
name = []
fibers = []
fiber_count = []
norm = matplotlib.colors.Normalize(vmin=1, vmax=72)

tractsfile = []

n = 1
for file in glob.glob("tractseg_output/TOM_trackings" + "/*.tck"):
    print("converting:"+file+" to "+str(n)+".json")
    tck = nb.streamlines.load(file)
    tractname = os.path.basename(file).split('.tck')[0]  
    name.append(np.array(tractname))
    
    fiber_count.append(len(tck.streamlines))
    streamlines = np.zeros([len(tck.streamlines)], dtype=object)
    for e in range(len(tck.streamlines)):
        streamlines[e] = np.transpose(tck.streamlines[e])
    fibers.append(np.reshape(streamlines, [len(tck.streamlines),1]))
    
    jsonfibers = np.reshape(streamlines, [len(tck.streamlines),1]).tolist()
    for i in range(len(jsonfibers)):
        jsonfibers[i] = [jsonfibers[i][0].tolist()]
    jsonfile = {'name': tractname, 'color': list(cm.nipy_spectral(norm(n)))[0:3], 'coords': jsonfibers}
    #list(colors[n])
    
    splitname = tractname.split('_')
    fullname = splitname[-1].capitalize()+' '+' '.join(splitname[0:-1])  
    
    tractsfile.append({"name": fullname, "color": list(cm.jet(norm(n)))[0:3], "filename": str(n)+'.json'})
    
    with open ('tracts/'+str(n)+'.json', 'w') as outfile:
        #json.dump(jsonfile, outfile, separators=(',', ': '), indent=4)
        json.dump(jsonfile, outfile)
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
