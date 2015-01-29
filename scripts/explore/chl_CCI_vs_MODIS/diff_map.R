library(raster)
library(ggplot2)
library(scales)
library(RColorBrewer)

outputDir <- 'derived/EDA/chl_CCI_vs_MODIS'
dir.create(outputDir, recursive=TRUE)

FILES_CCI <- list.files('data/chl_oc_cci/clean', pattern='*.grd', full.names=TRUE)
FILES_MODIS <- list.files('data/chl/clean', pattern='*.grd', full.names=TRUE)

date_from_filename_modis <- function(f) {
  b <- basename(f)
  b <- strsplit(b, '[.]')[[1]]
  b <- b[1]

  y <- substring(b, 2, 5)
  d <- as.numeric(substring(b, 6, 8))

  t <- as.Date(d - 1, origin=paste(y, '-01-01', sep=''))
  return(t)
}

date_from_filename_cci <- function(f) {
  b <- basename(f)
  b <- strsplit(b, '[.]')[[1]]
  b <- b[1]
  return(as.Date(b))
}

date_start <- as.Date('2003-01-01')
date_end <- as.Date('2012-01-01')
drange <- seq(date_start, date_end, by='year')

N <- 46*(length(drange) - 1)
modis_r <- array(NA, c(dim(as.matrix(FILES_MODIS[1])), N))

for (i in 1:length(FILES_MODIS)) {
  f <- FILES_MODIS[i]
  print(f)
  d <- date_from_filename_modis(f)
  if (d >= date_start $ d < date_end) {
    r <- raster(f)
    modis_r[,,i] <- as.matrix(r)
  }
}