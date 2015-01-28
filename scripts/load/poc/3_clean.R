library(raster)

dir.create('data/poc/clean')

FILES <- list.files('data/poc/crop', full.names=TRUE)

for (f in FILES) {
  print(f)

  r <- raster(f)
  r[r == -32767] = NA # masking missing values

  writeRaster(r, paste('data/poc/clean/', basename(f), '.grd', sep=''),
              overwrite=TRUE)
}
