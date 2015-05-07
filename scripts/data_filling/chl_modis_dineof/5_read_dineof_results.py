import numpy as np
import scipy.io as sio
import os
import numpy.ma as ma

nb_lats = 408
nb_lons = 288
T = 685
inputDir = 'derived/data_filling/chl_modis'
outputDir = 'data/filled_data/chl_modis'

if not os.path.exists(outputDir):
    os.makedirs(outputDir)

mask = sio.loadmat(os.path.join(inputDir, 'mask.mat'))['mask']
mask = mask == 0

eofs     = np.genfromtxt(os.path.join(inputDir, 'outputEof.lftvec'))
time_fct = np.genfromtxt(os.path.join(inputDir, 'outputEof.rghvec'))
s_values = np.genfromtxt(os.path.join(inputDir, 'outputEof.vlsng'))
varEx    = np.genfromtxt(os.path.join(inputDir, 'outputEof.varEx'))[:, 3]

sio.savemat(os.path.join(inputDir, 'eofs.mat'), {'eofs': eofs})
sio.savemat(os.path.join(inputDir, 's_values.mat'), {'s_values': s_values})
sio.savemat(os.path.join(inputDir, 'varEx.mat'), {'varEx': varEx})
sio.savemat(os.path.join(inputDir, 'time_fct.mat'), {'time_fct': time_fct})

mask[mask] = 1
sio.savemat(os.path.join(outputDir, 'mask.mat'), {'mask': mask})
