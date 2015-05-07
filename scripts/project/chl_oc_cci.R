library(raster)

out_dir <- 'data/chl_oc_cci/projected'

dir.create(out_dir, recursive=TRUE)

clusters <- raster('derived/clustering/with_seasonal_filling/clusters.grd')
chl <- brick('data/chl_oc_cci/filled/seasonal_filling/chl_filled.grd')
chl <- log(chl)

N <- nlayers(chl)

chl_1 <- c()
chl_2 <- c()
chl_3 <- c()
chl_4 <- c()

for (i in 1:N) {
  r <- raster(chl, layer=i)
  chl_1 <- c(chl_1, mean(r[clusters == 1]))
  chl_2 <- c(chl_2, mean(r[clusters == 2]))
  chl_3 <- c(chl_3, mean(r[clusters == 3]))
  chl_4 <- c(chl_4, mean(r[clusters == 4]))
}


# add dates
date_from_filename <- function(f) {
  b <- basename(f)
  b <- strsplit(b, '[.]')[[1]]
  b <- b[1]

  return(as.Date(b))
}

FILES <- list.files('data/chl_oc_cci/clean', full.names=TRUE,
                    pattern='*.grd')

d <- date_from_filename(FILES[1])
for (f in FILES) {
  d <- c(d, date_from_filename(f))
}
d <- d[4:688]

y = format(d, '%Y')

w = c()
for (i in 1:N) {
  w <- c(w, (i+32 - 1)%%46 + 1) 
}

df <- data.frame(year=y, week=w, chl_1, chl_2, chl_3, chl_4, row.names=d)
write.csv(df, file=paste(out_dir, 'chl_oc_cci.csv', sep='/'))