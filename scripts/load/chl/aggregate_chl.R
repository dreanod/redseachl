library(ncdf4)
library(abind)
library(reshape2)

chl_a2r <- function(lon, lat, x) {
  colnames(x) <-lat
  rownames(x) <- lon
  x <- melt(x)
  colnames(x) <- c('lon', 'lat', 'chl')
  
  coordinates(x) <- ~lon+lat
  x <- SpatialPixelsDataFrame(x@coords, x@data, tol=9.15583e-05)
  proj4string(x) <- CRS("+init=epsg:4326")
  chl_r <- raster(x)
  
  return(chl_r)
}

read_nc <- function(filename) {
  nc <- nc_open(filename)
  chl <- ncvar_get(nc, 'chlor_a')
  lon <- ncvar_get(nc, 'lon')
  lat <- ncvar_get(nc, 'lat')
  time <- ncvar_get(nc, 'time')
  nc_close(nc)
  
  return(list(chl=chl, lon=lon, lat=lat, time=time))
}

raw_dir <- 'data/raw/CHL'
agg_dir <- 'data/aggregates'
FILES <- list.files(raw_dir, pattern='*.nc', full.names=TRUE)

chl_b <- brick()

rastersList <- lapply(FILES, function(filename) {
  data <- read_nc(filename)
  
  tmpList <- lapply(1:length(data$time), function(i) {
    return(chl_a2r(data$lon, data$lat, data$chl[,,i]))
  })
  return(tmpList)
})
