import numpy as np
import scipy.io as sio

DATA = sio.loadmat('data/chl_oc_cci/clustering/chl_filled.mat')
chl = DATA['chl']

chl_pixel_scaled = scale(chl, axis=1, with_std=False)

chl_mean = chl.mean(axis=1)
chl_alt = chl - np.tile(chl_mean[:, np.newaxis], (1, 687))

chl_reduced = chl[:,16:-27]
chl_Seas = np.zeros([chl.shape[0], 4*14])
for y in range(14):
  chl_Seas[:, y*4] = chl_reduced[:, y*46:y*46 + 11].mean(axis=1)
  chl_Seas[:, y*4 + 1] = chl_reduced[:, y*46+11:y*46+23].mean(axis=1)
  chl_Seas[:, y*4 + 2] = chl_reduced[:, y*46+23:y*46+35].mean(axis=1)
  chl_Seas[:, y*4 + 3] = chl_reduced[:, y*46+35:y*46+46].mean(axis=1)

chl_winter = chl_Seas[:,0::4]
chl_spring = chl_Seas[:,1::4]
chl_summer = chl_Seas[:,2::4]
chl_fall = chl_Seas[:,3::4]

chl_winter_mean = chl_winter.mean(axis=1)
chl_spring_mean = chl_spring.mean(axis=1)
chl_summer_mean = chl_summer.mean(axis=1)
chl_fall_mean = chl_fall.mean(axis=1)
chl_winter_std = chl_winter.std(axis=1)
chl_spring_std = chl_spring.std(axis=1)
chl_summer_std = chl_summer.std(axis=1)
chl_fall_std = chl_fall.std(axis=1)

chl_seasonal_reduced = np.c_[chl_winter_mean, chl_spring_mean,
                             chl_summer_mean, chl_fall_mean]
#                             chl_winter_std, chl_spring_std,
#                             chl_summer_std, chl_fall_std]

chl_seasonal_reduced = scale(chl_seasonal_reduced)

chl_winter_scales = (chl_winter - chl_winter.mean())/chl_winter.std()
chl_spring_scales = (chl_spring - chl_spring.mean())/chl_spring.std()
chl_summer_scales = (chl_summer - chl_summer.mean())/chl_summer.std()
chl_fall_scales = (chl_fall - chl_fall.mean())/chl_fall.std()

chl_scaled = np.c_[chl_winter_scales, chl_spring_scales, chl_summer_scales, chl_fall_scales]

chl_winter_climatology_scaled = chl_winter_scales.mean(axis=1)
chl_spring_climatology_scaled = chl_spring_scales.mean(axis=1)
chl_summer_climatology_scaled = chl_summer_scales.mean(axis=1)
chl_fall_climatology_scaled = chl_fall_scales.mean(axis=1)

chl_climatology_scaled = np.c_[chl_winter_climatology_scaled,
                               chl_spring_climatology_scaled,
                               chl_summer_climatology_scaled,
                               chl_fall_climatology_scaled]

chl_anomalies = np.zeros_like(chl_reduced)
for i in range(46):
  seas = chl_reduced[:,i::46].mean(axis=1)
  chl_anomalies[:,i::46] = chl_reduced[:,i::46] - np.tile(seas[:,np.newaxis], (1, 14))
from sklearn.preprocessing import scale
chl_anomalies_scale = scale(chl_anomalies)

from sklearn.cluster import KMeans
estimator = KMeans(n_clusters=10).fit(chl)
labels = estimator.labels_
sio.savemat('derived/clustering/kmeans_10_clusters.mat', {'clusters':labels})

from sklearn.mixture import GMM
estimator = GMM(n_components=4, covariance_type='full').fit(chl_seasonal_reduced)
labels = estimator.predict(chl_seasonal_reduced)
sio.savemat('derived/clustering/gmm_full_4_clusters_seasonal_reduced.mat', {'clusters':labels})

# Mixed GMM clustering
from sklearn.mixture import GMM
estimator = GMM(n_components=4, covariance_type='full').fit(chl)
labels = estimator.predict(chl)
sio.savemat('derived/clustering/gmm_full_mixed_clusters_partial.mat', {'clusters':labels})
indNRS = labels == 0
chlNRS = chl[indNRS,:]
estimator = GMM(n_components = 4, covariance_type='full').fit(chlNRS)
labelsNRS = estimator.predict(chlNRS)
labels[indNRS] += labelsNRS + 5
sio.savemat('derived/clustering/gmm_full_mixed_clusters.mat', {'clusters':labels})


# Hierarchical GMM clustering
from sklearn.mixture import GMM
np.random.seed(1)
estimator = GMM(n_components=2, covariance_type='full').fit(chl)
labels = estimator.predict(chl)
sio.savemat('derived/clustering/gmm_full_hierarchical_clusters_1.mat', {'clusters':labels})
ind1 = labels == 1
chl1 = chl[ind1,:]
labels1 = GMM(n_components=2, covariance_type='full').fit(chl1).predict(chl1)
labels[ind1] = labels1 + 2
sio.savemat('derived/clustering/gmm_full_hierarchical_clusters_2.mat', {'clusters':labels})
ind2 = labels == 3
chl2 = chl[ind2,:]
labels2 = GMM(n_components=2, covariance_type='full').fit(chl2).predict(chl2)
labels[ind2] = labels2 + 4
sio.savemat('derived/clustering/gmm_full_hierarchical_clusters_3.mat', {'clusters':labels})

from sklearn.cluster import AffinityPropagation
estimator = AffinityPropagation().fit(chl_Seas)
labels = estimator.labels_
sio.savemat('derived/clustering/gmm_affinity_seas.mat', {'clusters':labels})

from sklearn.mixture import DPGMM
estimator = DPGMM(n_components=5).fit(chl)
labels = estimator.predict(chl)
sio.savemat('derived/clustering/dpgmm_5_clusters.mat', {'clusters':labels})

from sklearn.cluster import DBSCAN
estimator = DBSCAN(min_samples=10, metric='cityblock').fit(chl_climatology_scaled)
labels = estimator.labels_

from sklearn.cluster import MeanShift
ms = MeanShift(bin_seeding= True).fit(chl_anomalies_scale)
labels = ms.labels_
sio.savemat('derived/clustering/meanshift_clusters_climatology_scaled.mat', {'clusters':labels})

from sklearn.cluster import AgglomerativeClustering
estimator = AgglomerativeClustering(n_clusters=10, linkage='ward').fit(chl_climatology_scaled)
labels = estimator.labels_
sio.savemat('derived/clustering/ward_10_clusters_climatology_scaled.mat', {'clusters':labels})

from sklearn.decomposition import FastICA
estimator = FastICA().fit(chl)
components = estimator.components
sio.savemat('derived/clustering/fast_ica.mat', {'components': components})
