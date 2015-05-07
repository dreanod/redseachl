#!/usr/bin/bash

mkdir data/wind/raster_info

gdal_translate -b 1 data/wind/raw/MIT-01JAN01-01JAN02_u10.nc data/wind/raster_info/wind.tiff