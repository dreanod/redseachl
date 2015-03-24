import numpy as np
import scipy.io as sio
import os
import numpy.ma as ma

nb_lats = 408
nb_lons = 288
T = 685
outputDir = 'derived/data_filling'

mask = sio.loadmat(os.path.join(outputDir, 'mask.mat'))['mask']
mask = mask == 0

eofs     = np.genfromtxt(os.path.join(outputDir, 'outputEof.lftvec'))
time_fct = np.genfromtxt(os.path.join(outputDir, 'outputEof.rghvec'))
s_values = np.genfromtxt(os.path.join(outputDir, 'outputEof.vlsng'))
varEx    = np.genfromtxt(os.path.join(outputDir, 'outputEof.varEx'))[:, 3]

sio.savemat(os.path.join(outputDir, 'eofs.mat'), {'eofs': eofs})
sio.savemat(os.path.join(outputDir, 's_values.mat'), {'s_values': s_values})
sio.savemat(os.path.join(outputDir, 'varEx.mat'), {'varEx': varEx})
sio.savemat(os.path.join(outputDir, 'time_fct.mat'), {'time_fct': time_fct})
