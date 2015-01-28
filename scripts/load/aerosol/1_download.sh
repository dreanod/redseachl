#!/usr/bin/env bash

wget -nH -r -N --cut-dirs=8 --random-wait --wait 1 \
-P data/aerosol/raw --accept *.Optical_Depth_Land_And_Ocean_Mean.G3.hdf \
ftp://gdata1.sci.gsfc.nasa.gov//ftp/incoming/G3/OPS/cache/MOD08_D3.051/