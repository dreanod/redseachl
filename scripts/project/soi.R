in_dir <- 'data/soi/raw'
out_dir <- 'data/soi/projected'
df_file <- paste(out_dir, 'soi.csv', sep='/')

dir.create(out_dir)

FILES <- list.files('data/soi/raw', full.names=TRUE)
f <- FILES[1]

soi  <- c()
year <- c()
week <- c()
date <- c()

s <- read.table(f, header=TRUE)
year_start <- min(s$Year)
year_end   <- max(s$Year)

for (y in year_start:year_end) {
  s_sub <- subset(s, Year == y)
  current_date <- as.Date(paste(y, '-01-01', sep=''))
  w <- 1
  while (nrow(s_sub) > 0) {
    if (nrow(s_sub) >= 8) {
      soi <- c(soi, mean(s_sub$SOI[1:8]))
    } else {
      soi <- c(soi, mean(s_sub$SOI))
    }
    year <- c(year, y)
    week <- c(week, w)
    date <- c(date, as.character(current_date))
    s_sub <- s_sub[-seq(1,8),]

    current_date <- current_date + 8
    w <- w + 1
  }
}
df <- data.frame(year=year, week=week, soi=soi, row.names=date)
write.csv(df, file=df_file)