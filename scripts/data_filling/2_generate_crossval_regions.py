import os
import scipy.io as sio
import numpy.ma as ma
import numpy as np

out_dir = 'derived/data_filling'
chl_f = 'chl.mat'
mask_f = 'mask.mat'
crossval_f = 'crossval_mask.mat'

chl = sio.loadmat(os.path.join(out_dir, chl_f))['chl']
mask = sio.loadmat(os.path.join(out_dir, mask_f))['mask']
chl = ma.masked_invalid(chl)
[nlat, nlon, T] = chl.shape
mask = mask == 0
chl = chl[~mask, :]

# Extract array of clouds
clouds = chl.mask

# Sort space observations
clean_rank = np.sum(~clouds, axis=0)
clean_rank = np.argsort( clean_rank )

# Obscure data
nb_obs = np.sum( ~chl.mask )
nb_goal = np.floor( .03 * nb_obs )
nb_cross = 0
cloud_order = np.random.permutation(T)
cross_val_mask = np.zeros_like( clouds, dtype=bool )

i = 0
while nb_cross < nb_goal:
    i += 1
    cross_val_mask[ : , clean_rank[i] ] = np.logical_and(
        ~chl.mask[ :, clean_rank[i] ],
        clouds[ :, cloud_order[i] ])

    nb_cross += np.sum( cross_val_mask[ : , clean_rank[i] ] )

# Save mask
tmp = np.zeros( [nlat, nlon, T], dtype=bool )
tmp[~mask] = cross_val_mask
cross_val_mask = tmp
cross_val_mask = cross_val_mask.astype(int)

# indices
mindex = np.zeros( [ nlat, nlon ] )
m = 0
for i in range(nlat):
    for j in range(nlon):
        if not mask[ i , j ]:
            m += 1
            mindex[ i , j ] = m

nb_clouds = cross_val_mask.sum()
index = np.nonzero( cross_val_mask )
cloud_indexes = np.zeros( [ nb_clouds, 2 ] )    
for i in range( nb_clouds ):
    cloud_indexes[ i, 0 ] = mindex[ 
        index[0][i], index[1][i] ]
    cloud_indexes[ i, 1 ] = index[2][i]+1


sio.savemat(os.path.join(out_dir, crossval_f),
    {'cross':cross_val_mask,
     'indices':cloud_indexes})
