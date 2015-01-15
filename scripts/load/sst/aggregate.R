library(raster)

FILES <- list.files('data/sst/crop', full.names=TRUE)

d <- NULL
b <- brick()

for (f in FILES) {
  print(f)
  b <- brick(list(b, file))

  fname <- strsplit(f, '/')[[1]][4]
  year <- substr(fname, 2, 5)
  day  <- as.numeric(substr(fname, 6, 8))

  if (is.null(d)) {
    d <- as.Date(day - 1, origin=paste(year, '01-01', sep='-'))
  } else {
    d <- c(d, as.Date(day - 1, origin=paste(year, '01-01', sep='-')))
  }
}

b[b == 65535] = NA # masking missing values

# compute SST values
slope <- 0.000717184972
intercept <- -2
b <- slope*b + intercept

names(b) <- d
b <- setZ(b, d)

dir.create('data/sst/aggregate')
writeRaster(b, 'data/sst/aggregate/aggregate.grd', overwrite=TRUE)