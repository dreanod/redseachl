library(raster)
library(abind)
library(yaml)

FILES <- list.files('data/rain/raw', full.names=TRUE, pattern='*.bin')
s <- list()

config <- yaml.load_file('scripts/load/config.yml')
ext <- config$red_sea_extent
ext <- extent(c(ext$lon_min, ext$lon_max, ext$lat_min, ext$lat_max))

i = 1
for (f in FILES) {
  a <- readBin(f, numeric(), n=600000, size=4, endian='big')
  a <- t(array(a, c(1440, 400)))
  r <- raster(a, xmn=-180, xmx=180, ymn=-50, ymx=50)
  r <- crop(r, ext)
  s <- c(s, r)
}
s <- stack(s)

dir.create('data/rain/aggregate', recursive=TRUE)
writeRaster(s, 'data/rain/aggregate/rain.grd', overwrite=TRUE)