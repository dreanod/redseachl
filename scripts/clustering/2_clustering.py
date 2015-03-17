import numpy as np
import scipy.io as sio
from sklearn.mixture import GMM
import os

DATA = sio.loadmat('data/chl_oc_cci/clustering/chl_filled.mat')
chl = DATA['chl']

directory = 'data/clustering'
if not os.path.exists(directory):
    os.makedirs(directory)

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
sio.savemat(os.path.join('data/clustering', 'clusters_raw.mat'), {'clusters':labels})
