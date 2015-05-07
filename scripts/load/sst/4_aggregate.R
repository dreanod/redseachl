library(raster)

input_dir <- 'data/sst/clean/'
output_dir <- 'data/sst/aggregate'

dir.create(output_dir, recursive=TRUE)

FILES <- list.files(input_dir, full.names=TRUE, pattern='*.grd')

s <- stack()

for (f in FILES) {
  print(f)
  r <- raster(f)
  s <- stack(s, f)
}

fn <- paste(output_dir, '/', 'sst.grd', sep='')
writeRaster(s, fn, overwrite=TRUE)