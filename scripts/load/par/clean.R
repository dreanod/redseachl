library(raster)

dir.create('data/par/clean')

FILES <- list.files('data/par/crop', full.names=TRUE)

for (f in FILES) {
  print(f)

  r <- raster(f)
  r[r == -32767] = NA # masking missing values

  writeRaster(r, paste('data/par/clean/', basename(f), '.grd', sep=''))
}