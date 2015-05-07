library(raster)

ssh <- brick('data/ssh/aggregate/ssh.grd')
clusters <- brick('derived/clustering/with_seasonal_filling/clusters.grd')
out_dir <- 'data/ssh/projected'
dir.create(out_dir)

clusters <- resample(clusters, ssh, method='ngb') # Low resolution clusters
ssh <- crop(ssh, clusters)

ssh_1_tmp <- c()
ssh_2_tmp <- c()
ssh_3_tmp <- c()
ssh_4_tmp <- c()

for (i in 1:nlayers(ssh)) {
  r <- raster(ssh, layer=i)
  ssh_1_tmp <- c(ssh_1_tmp, mean(r[clusters == 1], na.rm=TRUE))
  ssh_2_tmp <- c(ssh_2_tmp, mean(r[clusters == 2], na.rm=TRUE))
  ssh_3_tmp <- c(ssh_3_tmp, mean(r[clusters == 3], na.rm=TRUE))
  ssh_4_tmp <- c(ssh_4_tmp, mean(r[clusters == 4], na.rm=TRUE))
}

year_start <- 1993
year_end <- 2013

dates <- c()
week <- c()
year <- c()
ssh_1 <- c()
ssh_2 <- c()
ssh_3 <- c()
ssh_4 <- c()

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

    ssh_1 <- c(ssh_1, mean(ssh_1_tmp[ind]))
    ssh_2 <- c(ssh_2, mean(ssh_2_tmp[ind]))
    ssh_3 <- c(ssh_3, mean(ssh_3_tmp[ind]))
    ssh_4 <- c(ssh_4, mean(ssh_4_tmp[ind]))

    ssh_1_tmp <- ssh_1_tmp[-ind]
    ssh_2_tmp <- ssh_2_tmp[-ind]
    ssh_3_tmp <- ssh_3_tmp[-ind]
    ssh_4_tmp <- ssh_4_tmp[-ind]

    current_date <- current_date + 8
  }
}

df <- data.frame(year=year, week=week, ssh_1, ssh_2, ssh_3, ssh_4, row.names=dates)

write.csv(df, paste(out_dir, 'ssh.csv', sep='/'))