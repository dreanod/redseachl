library(ncdf4)
library(abind)

raw_dir <- 'data/raw/CHL'
agg_dir <- 'data/aggregates'

FILES <- list.files(raw_dir, pattern='*.nc', full.names=TRUE)
CHL <- NULL

for (filename in FILES) {
  nc <- nc_open(filename)
  chl <- ncvar_get(nc, 'chlor_a')
  lon <- ncvar_get(nc, 'lon')
  lat <- ncvar_get(nc, 'lat')
  time <- ncvar_get(nc, 'time')
  CHL <- abind(CHL, chl, along=3)
  nc_close(nc)
}