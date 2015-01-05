library(ncdf4)
library(abind)
library(reshape2)
library(raster)
library(yaml)

config <- yaml.load_file('scripts/load/config.yml')
redSeaExtent <- extent(c(config$lon_min, config$lon_max, 
                         config$lat_min, config$lat_max))

chl_a2r <- function(lon, lat, x) {
  colnames(x) <-lat
  rownames(x) <- lon
  x <- melt(x)
  colnames(x) <- c('lon', 'lat', 'chl')
  
  coordinates(x) <- ~lon+lat
  x <- SpatialPixelsDataFrame(x@coords, x@data, tol=9.15583e-05)
  proj4string(x) <- CRS("+init=epsg:4326")
  chl_r <- raster(x)
  chl_r <- crop(chl_r, redSeaExtent)
  
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

raw_dir <- 'data/chl/raw'
agg_dir <- 'data/chl/aggregate'
FILES <- list.files(raw_dir, pattern='*.nc', full.names=TRUE)

chl_b <- brick()

bricksList <- lapply(FILES, function(filename) {
  print(paste('Reading file:', filename))
  data <- read_nc(filename)
  
  rastersList <- lapply(1:length(data$time), function(i) {
    return(chl_a2r(data$lon, data$lat, data$chl[,,i]))
  })
  chl_tmp <- brick(rastersList)
  chl_tmp <- setZ(chl_tmp, data$time)
  names(chl_tmp) <- data$time
  return(chl_tmp)
})

chl_r <- brick(bricksList)

filename <- paste(agg_dir, 'chl.grd', sep='/')
writeRaster(chl_r, filename, overwrite=TRUE)