library(raster)

dir.create('data/chl/clean/')

FILES <- list.files('data/chl/crop', full.names=TRUE)

for (f in FILES) {
  print(f)

  r <- raster(f)
  r[r == -32767] = NA # masking missing values

  writeRaster(r, paste('data/chl/clean/', basename(f), '.grd', sep=''))
}