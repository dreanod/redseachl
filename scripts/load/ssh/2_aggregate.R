library(raster)

FILES <- list.files('data/ssh/raw', full.name=TRUE)

brick_list <- list()

for (f in FILES) {
  brick_list <- c(brick_list, stack(f, varname='sla'))
}

b <- stack(brick_list)

dir.create('data/ssh/aggregate')
writeRaster(b, file='data/ssh/aggregate/ssh.grd', overwrite=TRUE)