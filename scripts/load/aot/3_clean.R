library(raster)

dir.create('data/aot/clean')

FILES <- list.files('data/aot/crop', full.names=TRUE)

for (f in FILES) {
  print(f)

  r <- raster(f)
  r[r == -32767] = NA # masking missing values

  # compute SST values
  slope <- 1
  intercept <- 0
  r <- slope * r + intercept

  writeRaster(r, paste('data/aot/clean/', basename(f), '.grd', sep=''),
              overwrite=TRUE)
}