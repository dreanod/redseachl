
url <- 'http://www.ngdc.noaa.gov/mgg/global/relief/ETOPO1/data/ice_surface/grid_registered/netcdf/ETOPO1_Ice_g_gdal.grd.gz'

flags <- '-N --wait=0.5 --force-html -P data/bathy/raw'
cmd <- paste('wget', url, flags)
system(cmd)
