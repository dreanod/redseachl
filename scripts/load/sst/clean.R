library(raster)

dir.create('data/sst/clean')

FILES <- list.files('data/sst/crop', full.names=TRUE)

for (f in FILES) {
  print(f)

  r <- raster(f)
  r[r == 65535] = NA # masking missing values

  # compute SST values
  slope <- 0.000717184972
  intercept <- -2
  r <- slope * r + intercept

  writeRaster(r, paste('data/sst/clean/', basename(f), '.grd', sep=''))
}