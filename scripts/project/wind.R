library(raster)

uwnd <- brick('data/wind/aggregate/uwnd.grd')
vwnd <- brick('data/wind/aggregate/vwnd.grd')
clusters <- brick('derived/clustering/with_seasonal_filling/clusters.grd')
out_dir <- 'data/wind/projected'
dir.create(out_dir)

clusters <- resample(clusters, uwnd, method='ngb') # Low resolution clusters
uwnd <- crop(uwnd, clusters)
vwnd <- crop(vwnd, clusters)

uwnd1_tmp <- c()
uwnd2_tmp <- c()
uwnd3_tmp <- c()
uwnd4_tmp <- c()
for (i in 1:nlayers(uwnd)) {
  r <- raster(uwnd, layer=i)
  uwnd1_tmp <- c(uwnd1_tmp, mean(r[clusters == 1], na.rm=TRUE))
  uwnd2_tmp <- c(uwnd2_tmp, mean(r[clusters == 2], na.rm=TRUE))
  uwnd3_tmp <- c(uwnd3_tmp, mean(r[clusters == 3], na.rm=TRUE))
  uwnd4_tmp <- c(uwnd4_tmp, mean(r[clusters == 4], na.rm=TRUE))
}

vwnd1_tmp <- c()
vwnd2_tmp <- c()
vwnd3_tmp <- c()
vwnd4_tmp <- c()
for (i in 1:nlayers(vwnd)) {
  r <- raster(vwnd, layer=i)
  vwnd1_tmp <- c(vwnd1_tmp, mean(r[clusters == 1], na.rm=TRUE))
  vwnd2_tmp <- c(vwnd2_tmp, mean(r[clusters == 2], na.rm=TRUE))
  vwnd3_tmp <- c(vwnd3_tmp, mean(r[clusters == 3], na.rm=TRUE))
  vwnd4_tmp <- c(vwnd4_tmp, mean(r[clusters == 4], na.rm=TRUE))
}

year_start <- 2000
year_end <- 2013

dates <- c()
week <- c()
year <- c()

uwnd1 <- c()
uwnd2 <- c()
uwnd3 <- c()
uwnd4 <- c()

vwnd1 <- c()
vwnd2 <- c()
vwnd3 <- c()
vwnd4 <- c()

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

    uwnd1 <- c(uwnd1, mean(uwnd1_tmp[ind]))
    uwnd2 <- c(uwnd2, mean(uwnd2_tmp[ind]))
    uwnd3 <- c(uwnd3, mean(uwnd3_tmp[ind]))
    uwnd4 <- c(uwnd4, mean(uwnd4_tmp[ind]))

    vwnd1 <- c(vwnd1, mean(vwnd1_tmp[ind]))
    vwnd2 <- c(vwnd2, mean(vwnd2_tmp[ind]))
    vwnd3 <- c(vwnd3, mean(vwnd3_tmp[ind]))
    vwnd4 <- c(vwnd4, mean(vwnd4_tmp[ind]))

    uwnd1_tmp <- uwnd1_tmp[-ind]
    uwnd2_tmp <- uwnd2_tmp[-ind]
    uwnd3_tmp <- uwnd3_tmp[-ind]
    uwnd4_tmp <- uwnd4_tmp[-ind]

    vwnd1_tmp <- vwnd1_tmp[-ind]
    vwnd2_tmp <- vwnd2_tmp[-ind]
    vwnd3_tmp <- vwnd3_tmp[-ind]
    vwnd4_tmp <- vwnd4_tmp[-ind]

    current_date <- current_date + 8
  }
}

df <- data.frame(year=year, week=week, uwnd1, uwnd2, uwnd3, uwnd4, 
                 vwnd1, vwnd2, vwnd3, vwnd4, row.names=dates)

write.csv(df, paste(out_dir, 'wind.csv', sep='/'))