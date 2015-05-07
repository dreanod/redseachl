library(raster)
library(yaml)

out_dir <- 'data/sst/projected'

clusters <- raster('derived/clustering/with_seasonal_filling/clusters.grd')
sst <- brick('data/sst/aggregate/sst.grd')

dir.create(out_dir, recursive=TRUE)

config <- yaml.load_file('scripts/load/config.yml')
ext <- config$red_sea_extent
ext <- extent(c(ext$lon_min, ext$lon_max, ext$lat_min, ext$lat_max))
sst <- crop(sst, ext)

N <- nlayers(sst)

sst_1 <- c()
sst_2 <- c()
sst_3 <- c()
sst_4 <- c()

for (i in 1:N) {
  r <- raster(sst, layer=i)
  sst_1 <- c(sst_1, mean(r[clusters == 1], na.rm=TRUE))
  sst_2 <- c(sst_2, mean(r[clusters == 2], na.rm=TRUE))
  sst_3 <- c(sst_3, mean(r[clusters == 3], na.rm=TRUE))
  sst_4 <- c(sst_4, mean(r[clusters == 4], na.rm=TRUE))
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

FILES <- list.files('data/sst/clean', full.names=TRUE,
                    pattern='*.grd')

d <- date_from_filename(FILES[1])
for (f in FILES) {
  d <- c(d, date_from_filename(f))
}
d <- d[2:(N+1)]

y = format(d, '%Y')

w = c()
for (i in 1:N) {
  w <- c(w, (i+24 - 1)%%46 + 1) 
}

df <- data.frame(year=y, week=w, sst_1, sst_2, sst_3, sst_4, row.names=d)

write.csv(df, paste(out_dir, 'sst.csv', sep='/'))