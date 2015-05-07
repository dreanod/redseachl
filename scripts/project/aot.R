library(raster)
library(yaml)

out_dir <- 'data/aot/projected'

clusters <- raster('derived/clustering/with_seasonal_filling/clusters.grd')
aot <- brick('data/aot/aggregate/aot.grd')

dir.create(out_dir, recursive=TRUE)

config <- yaml.load_file('scripts/load/config.yml')
ext <- config$red_sea_extent
ext <- extent(c(ext$lon_min, ext$lon_max, ext$lat_min, ext$lat_max))
aot <- crop(aot, ext)

N <- nlayers(aot)

aot_1 <- c()
aot_2 <- c()
aot_3 <- c()
aot_4 <- c()

for (i in 1:N) {
  r <- raster(aot, layer=i)
  aot_1 <- c(aot_1, mean(r[clusters == 1], na.rm=TRUE))
  aot_2 <- c(aot_2, mean(r[clusters == 2], na.rm=TRUE))
  aot_3 <- c(aot_3, mean(r[clusters == 3], na.rm=TRUE))
  aot_4 <- c(aot_4, mean(r[clusters == 4], na.rm=TRUE))
}


# add dates
date_from_filename <- function(f) {
  b <- basename(f)
  b <- strsplit(b, '[.]')[[1]]
  b <- b[1]

  y <- substring(b, 2, 5)
  d <- as.numeric(substring(b, 6, 8))

  t <- as.Date(d - 1, origin=paste(y, '-01-01-', sep=''))
  return(t)
}

FILES <- list.files('data/aot/clean', full.names=TRUE,
                    pattern='*.grd')

d <- date_from_filename(FILES[1])
for (f in FILES) {
  d <- c(d, date_from_filename(f))
}
d <- d[2:(N+1)]

y = format(d, '%Y')

w = c()
for (i in 1:N) {
  w <- c(w, (i+23 - 1)%%46 + 1) 
}

df <- data.frame(year=y, week=w, aot_1, aot_2, aot_3, aot_4, row.names=d)

write.csv(df, paste(out_dir, 'aot.csv', sep='/'))