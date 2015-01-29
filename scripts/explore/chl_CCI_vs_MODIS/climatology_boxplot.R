library(raster)
library(ggplot2)
library(yaml)

outputDir <- 'derived/EDA/chl_CCI_vs_MODIS'
dir.create(outputDir, recursive=TRUE)

config <- yaml.load_file('scripts/load/config.yml')
NRS <- config$NRS
NCRS <- config$NCRS
SCRS <- config$SCRS
SRS <- config$SRS

NRS <- extent(c(NRS$lon_min, NRS$lon_max, NRS$lat_min, NRS$lat_max))
NCRS <- extent(c(NCRS$lon_min, NCRS$lon_max, NCRS$lat_min, NCRS$lat_max))
SCRS <- extent(c(SCRS$lon_min, SCRS$lon_max, SCRS$lat_min, SCRS$lat_max))
SRS <- extent(c(SRS$lon_min, SRS$lon_max, SRS$lat_min, SRS$lat_max))

FILES_CCI <- list.files('data/chl_oc_cci/clean', pattern='*.grd', full.names=TRUE)
FILES_MODIS <- list.files('data/chl/clean', pattern='*.grd', full.names=TRUE)

date_from_filename_modis <- function(f) {
  b <- basename(f)
  b <- strsplit(b, '[.]')[[1]]
  b <- b[1]

  y <- substring(b, 2, 5)
  d <- as.numeric(substring(b, 6, 8))

  t <- as.Date(d - 1, origin=paste(y, '-01-01-', sep=''))
  return(t)
}

date_from_filename_cci <- function(f) {
  b <- basename(f)
  b <- strsplit(b, '[.]')[[1]]
  b <- b[1]
  return(as.Date(b))
}

df <- NULL

for (f in FILES_MODIS) {
  print(f)
  d <- date_from_filename_modis(f)
  r <- raster(f)

  r_nrs <- crop(r, NRS)
  r_ncrs <- crop(r, NCRS)
  r_scrs <- crop(r, SCRS)
  r_srs <- crop(r, SRS)

  v_nrs <- as.vector(r_nrs)
  v_ncrs <- as.vector(r_ncrs)
  v_scrs <- as.vector(r_scrs)
  v_srs <- as.vector(r_srs)

  df_nrs <- data.frame(chl=v_nrs)
  df_nrs$region <- 'NRS'

  df_ncrs <- data.frame(chl=v_ncrs)
  df_ncrs$region <- 'NCRS'

  df_scrs <- data.frame(chl=v_scrs)
  df_scrs$region <- 'SCRS'

  df_srs <- data.frame(chl=v_srs)
  df_srs$region <- 'SRS'

  df_temp <- rbind(df_nrs, df_ncrs, df_scrs, df_srs)
  df_temp$date <- d
  df <- rbind(df, df_temp)
}

library(reshape2)

df <- melt(df, value.name='chl', variable.name='region',
           measure.vars=c('NRS', 'NCRS', 'SCRS', 'SRS'))