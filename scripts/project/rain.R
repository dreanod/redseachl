library(raster)

rain <- brick('data/rain/aggregate/rain.grd')
clusters <- brick('derived/clustering/with_seasonal_filling/clusters.grd')
out_dir <- 'data/rain/projected'
dir.create(out_dir)

clusters <- resample(clusters, rain, method='ngb') # Low resolution clusters
rain <- crop(rain, clusters)

rain_1_tmp <- c()
rain_2_tmp <- c()
rain_3_tmp <- c()
rain_4_tmp <- c()

for (i in 1:nlayers(rain)) {
  r <- raster(rain, layer=i)
  rain_1_tmp <- c(rain_1_tmp, mean(r[clusters == 1], na.rm=TRUE))
  rain_2_tmp <- c(rain_2_tmp, mean(r[clusters == 2], na.rm=TRUE))
  rain_3_tmp <- c(rain_3_tmp, mean(r[clusters == 3], na.rm=TRUE))
  rain_4_tmp <- c(rain_4_tmp, mean(r[clusters == 4], na.rm=TRUE))
}

year_start <- 1998
year_end <- 2013

dates <- c()
week <- c()
year <- c()
rain_1 <- c()
rain_2 <- c()
rain_3 <- c()
rain_4 <- c()

for (y in year_start:year_end) {
  current_date <- as.Date(paste(y, '-01-01', sep=''))

  for (w in 1:46) {
    if (w < 46) {
      ind <- 1:8
    } else {
      if (y %% 4 == 0) {
        ind <- 6
      } else {
        ind <- 5
      }
    }
    year <- c(year, y)
    week <- c(week, w)
    dates <- c(dates, as.character(current_date))

    rain_1 <- c(rain_1, mean(rain_1_tmp[ind]))
    rain_2 <- c(rain_2, mean(rain_2_tmp[ind]))
    rain_3 <- c(rain_3, mean(rain_3_tmp[ind]))
    rain_4 <- c(rain_4, mean(rain_4_tmp[ind]))

    rain_1_tmp <- rain_1_tmp[-ind]
    rain_2_tmp <- rain_2_tmp[-ind]
    rain_3_tmp <- rain_3_tmp[-ind]
    rain_4_tmp <- rain_4_tmp[-ind]

    current_date <- current_date + 8
  }
}

df <- data.frame(year=year, week=week, rain_1, rain_2, rain_3, rain_4, row.names=dates)

write.csv(df, paste(out_dir, 'rain.csv', sep='/'))