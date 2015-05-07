import numpy as np
import scipy.io as sio
from sklearn.mixture import GMM
import os

out_dir = 'derived/clustering/with_seasonal_filling'
in_dir = 'data/chl_oc_cci/filled/seasonal_filling'
in_chl_file = os.path.join(in_dir, 'chl_filled.mat')
in_mask_file = os.path.join(in_dir, 'mask.mat')
out_clusters_file = os.path.join(out_dir, 'clusters.mat')

chl = sio.loadmat(in_chl_file)['chl']
mask = sio.loadmat(in_mask_file)['mask']
mask = mask == 1

chl = chl[~mask, :]
chl = np.log(chl)

if not os.path.exists(out_dir):
    os.makedirs(out_dir)

# Hierarchical GMM clustering
np.random.seed(1)
estimator = GMM(n_components=2, covariance_type='full').fit(chl)
labels = estimator.predict(chl)
ind1 = labels == 1
chl1 = chl[ind1,:]
labels1 = GMM(n_components=2, covariance_type='full').fit(chl1).predict(chl1)
labels[ind1] = labels1 + 1
ind2 = labels == 2
chl2 = chl[ind2,:]
labels2 = GMM(n_components=2, covariance_type='full').fit(chl2).predict(chl2)
labels[ind2] = labels2 + 2
labels += 1
clusters = np.zeros(mask.shape)
clusters[:] = -1
clusters[~mask] = labels
sio.savemat(out_clusters_file, {'clusters':clusters})
