in_dir <- 'data/nao/raw'
out_dir <- 'data/nao/projected'
df_file <- paste(out_dir, 'nao.csv', sep='/')

dir.create(out_dir)

FILES <- list.files('data/nao/raw', full.names=TRUE)
f <- FILES[1]

nao  <- c()
year <- c()
week <- c()
date <- c()

s <- read.table(f, col.names=c('year', 'month', 'day', 'nao'))
year_start <- min(s$year)
year_end   <- max(s$year)

for (y in year_start:year_end) {
  s_sub <- subset(s, year == y)
  w <- 1
  while (nrow(s_sub) > 0) {
    if (nrow(s_sub) >= 8) {
      nao <- c(nao, mean(s_sub$nao[1:8]))
    } else {
      nao <- c(nao, mean(s_sub$nao))
    }
    year <- c(year, y)
    week <- c(week, w)
    current_date <- as.Date(paste(s_sub$year[1], s_sub$month[1],
                                  s_sub$day[1], sep='-'))
    date <- c(date, as.character(current_date))
    s_sub <- s_sub[-seq(1,8),]
    w <- w + 1
  }
}
df <- data.frame(year=year, week=week, nao=nao, row.names=date)
write.csv(df, file=df_file)