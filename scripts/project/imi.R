in_dir <- 'data/imi/raw'
out_dir <- 'data/imi/projected'
df_file <- paste(out_dir, 'imi.csv', sep='/')

dir.create(out_dir)

FILES <- list.files('data/imi/raw', full.names=TRUE)

imi  <- c()
year <- c()
week <- c()
date <- c()

for (f in FILES) {
  s <- read.table(f, skip=1, col.names=c('day', 'IMI'))
  y <- as.numeric(strsplit(f, split='[.]')[[1]][2])
  current_date <- as.Date(paste(y, '-01-01', sep=''))
  
  for (w in 1:46) {
    day_start <- (w-1)*8 + 1
    if (w == 46) {
      day_end <- s$day[nrow(s)]
    } else {
    day_end   <- w*8
    }
  
    imi  <- c(imi, mean(s$IMI[day_start:day_end]))
    year <- c(year, y)
    week <- c(week, w)
    date <- c(date, as.character(current_date))
  
    current_date <- current_date + 8
  }
}

df <- data.frame(year=year, week=week, imi=imi, row.names=date)
write.csv(df, file=df_file)