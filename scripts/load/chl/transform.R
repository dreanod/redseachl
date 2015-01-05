library(raster)

chl_b <- brick('data/chl/aggregate/chl')
chl_b <- log(chl_b)

dir.create('data/chl/transform')
writeRaster(chl_b, 'data/chl/transform/chl.grd', overwrite=TRUE)
