library(R.utils)
library(raster)
library(RCurl)
library(yaml)

cst <- yaml.load_file('config.yml')
dataDir <- "../../data"

for (year in cst$year_begin:cst$year_end) {
  day_end <- 0
  i <- 0
  nb_days = 365
  if (year %% 4 == 0) nb_days <- 366 # bissextile years
  while(day_end < nb_days) {
    i <- i + 1
    day_start <- (i - 1) * 8 + 1
    day_end <- day_start + 7
    if (day_end > nb_days) day_end <- nb_days
    filename <- paste('A', year, sprintf('%03d', day_start), 
                      year, sprintf('%03d', day_end), 
                      cst$chl_file_suffix, sep='')
    url <- paste(cst$chl_url, filename, sep='/')
    
    fileConn <- file(paste('generated/', filename, ".txt", sep=''))
    writeLines(url , fileConn)
    close(fileConn)
  }
}