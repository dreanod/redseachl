import scipy.io as sio
import numpy as np

DATA = sio.loadmat('data/chl_oc_cci/aggregate/chl_oc_cci.mat')
lon = DATA['lon']
lat = DATA['lat']
chl = DATA['chl']

mask = np.isnan(chl)
mask = np.sum(mask, 2)
mask = mask > 200

chl = chl[~mask, :]

import os
if not os.path.exists('data/chl_oc_cci/clustering'):
  os.makedirs('data/chl_oc_cci/clustering')

lon.dump('data/chl_oc_cci/clustering/lon.npy')
lat.dump('data/chl_oc_cci/clustering/lat.npy')
chl.dump('data/chl_oc_cci/clustering/chl.npy')
mask.dump('data/chl_oc_cci/clustering/mask.npy')