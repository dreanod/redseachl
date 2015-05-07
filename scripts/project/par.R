library(raster)
library(yaml)

out_dir <- 'data/par/projected'

clusters <- raster('derived/clustering/with_seasonal_filling/clusters.grd')
par <- brick('data/par/aggregate/par.grd')

dir.create(out_dir, recursive=TRUE)

config <- yaml.load_file('scripts/load/config.yml')
ext <- config$red_sea_extent
ext <- extent(c(ext$lon_min, ext$lon_max, ext$lat_min, ext$lat_max))
par <- crop(par, ext)

N <- nlayers(par)

par_1 <- c()
par_2 <- c()
par_3 <- c()
par_4 <- c()

for (i in 1:N) {
  r <- raster(par, layer=i)
  par_1 <- c(par_1, mean(r[clusters == 1], na.rm=TRUE))
  par_2 <- c(par_2, mean(r[clusters == 2], na.rm=TRUE))
  par_3 <- c(par_3, mean(r[clusters == 3], na.rm=TRUE))
  par_4 <- c(par_4, mean(r[clusters == 4], na.rm=TRUE))
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

FILES <- list.files('data/par/clean', full.names=TRUE,
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

df <- data.frame(year=y, week=w, par_1, par_2, par_3, par_4, row.names=d)

write.csv(df, paste(out_dir, 'par.csv', sep='/'))