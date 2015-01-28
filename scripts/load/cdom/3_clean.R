library(raster)

dir.create('data/cdom/clean')

FILES <- list.files('data/cdom/crop', full.names=TRUE)

for (f in FILES) {
  print(f)

  r <- raster(f)
  r[r == -32767] = NA # masking missing values

  writeRaster(r, paste('data/cdom/clean/', basename(f), '.grd', sep=''))
}
