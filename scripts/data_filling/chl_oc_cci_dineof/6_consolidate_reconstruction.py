import scipy.io as sio
import numpy.ma as ma

chl_filled = sio.loadmat('derived/data_filling/chl_filled.mat')['chl_filled']
chl_filled = ma.masked_invalid(chl_filled)

chl = sio.loadmat('data/filled_data/chl.mat')
chl = ma.masked_invalid(chl)
chl = chl['chl_filled']
mask = mask['mask']
chl_original = sio.loadmat('data/chl_oc_cci/aggregate/chl_oc_cci.mat')
chl_original = chl_original['chl']
chl_original = chl_original[:,:,2:]
chl_original = ma.masked_invalid(chl_original)