library(raster)
 
FILES <- list.files('data/sst/clean', full.names=TRUE, pattern='*.grd')
values = vector()

for (f in FILES) {
  print(f)

  r <- raster(f)

  values = c(values, as.vector(r))
}

hist(values)