library(raster)
library(ncdf)

outputDir <- 'data/chl_oc_cci/clean'
dir.create(outputDir, recursive=TRUE)
inputDir <- 'data/chl_oc_cci/raw'
FILES <- list.files(inputDir, full.names=TRUE)

for (f in FILES) {
  print(f)
  nc <- open.ncdf(f)
  chl <- get.var.ncdf(nc)
  lat <- get.var.ncdf(nc, 'lat')
  lon <- get.var.ncdf(nc, 'lon')
  time <- get.var.ncdf(nc, 'time')

  for (t in 1:length(time)) {
    dat <- list()
    dat$x <- lon
    dat$y <- rev(lat)
    dat$z <- t(apply(chl[,,t], 1, rev))

    r <- raster(dat)

    fn <- paste(outputDir, '/', as.Date(time[t]), '.grd', sep='')
    writeRaster(r, fn, overwrite=TRUE)
  }
}