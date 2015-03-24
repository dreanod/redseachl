#import numpy.ma as ma
import netCDF4 as nc
import subprocess
import struct
from os.path import expanduser

# Begin function /dineof/
def dineof(data, mask, dineof_param_file):
    '''
    Purpose   : Execute the DINEOF data filling algorithm using
                the tool downloaded from:
                http://http://modb.oce.ulg.ac.be
    Arguments : 
      * data - nlat x nlon x T masked array of data to be filled.
      * mask - nlat x nlon boolean array indicating land pixels
               (data not to be completed).
      * path_to_dineof - path to the executable tool
      * dineof_param_file - path to the dineof file to set the 
                            parameters of the tool.
    Returns   : 
      * data_filled - nlat x nlon x T filled masked array
      * eofs - nlat x nlon x neof masked array of the EOF loadings
        of the filled data array.
      * s_values - neof vector of the singular values of the 
        filled data array.
      * time_fct - T x neof matrix of the EOF time-series
        of the filled data matrix.
    Throws    : none
    '''
    data = data.copy()
    data[data.mask] = np.nan
    ## prepare the data in NetCDF format for DINEOF program
    [nb_lats, nb_lons, T] = np.shape(data)

    # data file
    f = nc.Dataset('derived/data_filling/data.nc', 'w')
    f.createDimension('time', T)
    f.createDimension('lons', nb_lons)
    f.createDimension('lats', nb_lats)

    time = f.createVariable('time', 'd', ('time',))
    time[:] = np.arange(T)

    data_nc = f.createVariable('data', 'd', ('time', 'lons', 'lats'))
    data_nc[:, :, :] = np.transpose(data, [2, 1, 0])
    f.close()

    # mask file
    f = nc.Dataset('derived/data_filling/mask.nc', 'w')
    f.createDimension('lons', nb_lons)
    f.createDimension('lats', nb_lats)

    mask_nc = f.createVariable('mask', 'd', ('lons', 'lats'))
    tmp = np.ones([nb_lons, nb_lats])
    tmp[mask.T] = 0.
    mask_nc[:, :] = tmp
    f.close()

    # run dineof command
#    command = path_to_dineof + ' ' + dineof_param_file + '; exit 0'
#    output = subprocess.check_output(command, stderr=subprocess.STDOUT,
#                                     shell=True) ## TODO Security issue

#    print output
    # f = open( 'log', 'w' )
    # f.write( output )
    # f.close()

#    output_lines = output.splitlines()
#    index_recon = output_lines.index(
#        '  Minimum reached in cross-validation') - 2
#    exp_error = float(output_lines[index_recon].split()[1])

#    if cv_mode:
#        print exp_error
#    else:
#        exp_error = np.nan
#        print output

## End function /dineof/

## Begin setting DINEOF parameters
params = dict()
params[ 'data' ]  = '[data.nc#data]'
params[ 'mask' ]  = "['mask.nc#mask']"
params[ 'time' ]  = "'data.nc#time'"
params[ 'alpha' ] = '0.005'
params[ 'numit' ] = '30'
#
# Sets the numerical variables for the computation of the required
# singular values and associated modes.
#
# Give 'nev' the maximum number of modes you want to compute 
params[ 'nev' ]   = '30'
#
# Give 'neini' the minimum  number of modes you want to compute 
#
params[ 'neini' ] = '2'
#
# Give 'ncv' the maximal size for the Krylov subspace 
# (Do not change it as soon as ncv > nev+5) 
# ncv must also be smaller than the temporal size of your matrix
#
params[ 'ncv' ]   = '56'
#
# Give 'tol' the treshold for Lanczos convergence 
# By default 1.e-8 is quite reasonable 
#
params[ 'tol' ] = '1.0e-8'
#
# Parameter 'nitemax' defining the maximum number of iteration allowed 
# for the stabilisation of eofs obtained by the cycle ((eof
# decomposition <-> truncated reconstruction and replacement of missing
# data)). An automatic criteria is defined by the following parameter
# 'itstop' to go faster 
#
params[ 'nitemax' ] = '1000'
#
# Parameter 'toliter' is a precision criteria defining the threshold
# of automatic stopping of dineof iterations, once the ratio 
# (rms of successive missing data reconstruction)/stdv(existing data) 
# becomes lower than 'toliter'. 
#
params[ 'toliter' ] = '1.0e-3'
#
# Parameter 'rec' for complete reconstruction of the matrix 
# rec=1 will reconstruct all points; rec=0 only missing points
#
params[ 'rec' ] = '1'
#
# Parameter 'eof' for writing the left and right modes of the
# input matrix. Disabled by default. To activate, set to 1
#
params[ 'eof' ] = '1'
#
# Parameter 'norm' to activate the normalisation of the input matrix
# for multivariate case. Disabled by default. To activate, set to 1
#
params[ 'norm' ] = '0'
#
# Output folder. Left and Right EOFs will be written here     
#
params[ 'Output' ] = '.'
#
# user chosen cross-validation points, 
# remove or comment-out the following entry if the cross-validation 
# points are to be chosen 
# internally
#
# clouds = 'crossvalidation.clouds'
params[ 'clouds' ] = 'crossval_mask.dat'
#print params['clouds']
#
# "results" contains the filenames of the filled data
#
#results = ['All_95_1of2.sst.filled']
#results = ['Output/F2Dbelcolour_region_period_datfilled.gher']
#
params[ 'results' ] = "['chl.filled']"
# params[ 'results' ] = "['chl.filled']"
#
# seed to initialize the random number generator
#
params[ 'seed' ] = '243435'
#
#
#!-------------------------!
#! cross-validation points !
#!-------------------------!
#
#number_cv_points = 7000
#
#cloud surface size in pixels 
#params[ 'cloud_size' ] = '100'
#
#cloud_mask = 'crossvalidation.mask'
# params[ 'cloud_mask' ] = 'crossvalidation.mask'
#
## End Setting DINEOF paramters

## Begin function /genParamFile/
def genParamFile(params, param_file):
    str = ''
    for key in params:
        str += key + ' = ' + params[ key ] + '\n'
        
    f = open(param_file, 'w')
    f.write(str)
    f.close()
## End function /genParamFile/












import os
import scipy.io as sio
import numpy.ma as ma
import numpy as np

chl = sio.loadmat('derived/data_filling/chl.mat')['chl']
mask = sio.loadmat('derived/data_filling/mask.mat')['mask']
chl = ma.masked_invalid(chl)
chl = np.log(chl)
mask = mask == 0

param_file = 'derived/data_filling/dineof.init'

genParamFile( params, param_file )

dineof(chl, mask, param_file)





