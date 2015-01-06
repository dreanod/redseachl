library(raster)

chl_b <- brick('data/chl/aggregate/chl')
logchl_b <- log(chl_b)

logchl_b <- setZ(logchl_b, getZ(chl_b))
names(logchl_b) <- names(chl_b)

dir.create('data/chl/transform')
writeRaster(logchl_b, 'data/chl/transform/chl.grd', overwrite=TRUE)
