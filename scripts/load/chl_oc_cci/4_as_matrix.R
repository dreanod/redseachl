library(raster)
library(yaml)
library(R.matlab)

config <- yaml.load_file('scripts/load/config.yml')
ext <- config$red_sea_extent
ext <- extent(c(ext$lon_min, ext$lon_max, ext$lat_min, ext$lat_max))

s <- brick('data/chl_oc_cci/aggregate/chl_oc_cci.grd')
s <- crop(s, ext)

latlon <- coordinates(s)
lon <- latlon[,1]
lat <- latlon[,2]
lon <- sort(unique(lon))
lat <- sort(unique(lat))

s <- as.array(s)

writeMat('data/chl_oc_cci/aggregate/chl_oc_cci.mat', chl=s, lat=lat, lon=lon)