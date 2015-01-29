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

v_nrs <- vector()
v_ncrs <- vector()
v_scrs <- vector()
v_srs <- vector()
d <- NULL

for (f in FILES_MODIS) {
  print(f)
  if (is.null(d)) {
    d <- date_from_filename_modis(f)
  }
  else {
    d <- c(d, date_from_filename_modis(f))
  }
  r <- raster(f)

  r_nrs <- crop(r, NRS)
  r_ncrs <- crop(r, NCRS)
  r_scrs <- crop(r, SCRS)
  r_srs <- crop(r, SRS)

  v_nrs <- c(v_nrs, median(r_nrs[,], na.rm=TRUE))
  v_ncrs <- c(v_ncrs, median(r_ncrs[,], na.rm=TRUE))
  v_scrs <- c(v_scrs, median(r_scrs[,], na.rm=TRUE))
  v_srs <- c(v_srs, median(r_srs[,], na.rm=TRUE))
}

df_modis <- data.frame(date=d, NRS=v_nrs, NCRS=v_ncrs, SCRS=v_scrs, SRS=v_srs)

v_nrs <- vector()
v_ncrs <- vector()
v_scrs <- vector()
v_srs <- vector()
d <- NULL

for (f in FILES_CCI) {
  print(f)
  if (is.null(d)) {
    d <- date_from_filename_cci(f)
  }
  else {
    d <- c(d, date_from_filename_cci(f))
  }
  r <- raster(f)

  r_nrs <- crop(r, NRS)
  r_ncrs <- crop(r, NCRS)
  r_scrs <- crop(r, SCRS)
  r_srs <- crop(r, SRS)

  v_nrs <- c(v_nrs, median(r_nrs[,], na.rm=TRUE))
  v_ncrs <- c(v_ncrs, median(r_ncrs[,], na.rm=TRUE))
  v_scrs <- c(v_scrs, median(r_scrs[,], na.rm=TRUE))
  v_srs <- c(v_srs, median(r_srs[,], na.rm=TRUE))
}

df_cci <- data.frame(date=d, NRS=v_nrs, NCRS=v_ncrs, SCRS=v_scrs, SRS=v_srs)

library(reshape2)
df_cci$product <- 'CCI'
df_cci <- melt(df_cci, value.name='chl', variable.name='region',
               measure.vars=c('NRS', 'NCRS', 'SCRS', 'SRS'))

df_modis$product <- 'MODIS'
df_modis <- melt(df_modis, value.name='chl', variable.name='region',
                 measure.vars=c('NRS', 'NCRS', 'SCRS', 'SRS'))

df <- rbind(df_cci, df_modis)

df$region <- as.factor(df$region)
df$product <- as.factor(df$product)

# look at the range of common dates for both data sets
date_start <- as.Date('2003-01-01')
date_end <- as.Date('2012-01-01')
drange <- seq(date_start, date_end, by='year')
dlabels <- as.character(seq(2003, 2012))
df <- subset(df, date > date_start & date < date_end)

p <- ggplot(subset(df, region=='NRS'), aes(x=date, y=chl, colour=product))
p <- p + geom_line() + geom_point()
p <- p + scale_x_date(labels=dlabels, breaks=drange)
p <- p + ggtitle('median CHL in NRS by data product')
fn <- paste(outputDir, '/ts_NRS_median.png', sep='')
ggsave(plot=p, filename=fn)

p <- ggplot(subset(df, region=='NCRS'), aes(x=date, y=chl, colour=product))
p <- p + geom_line() + geom_point()
p <- p + scale_x_date(labels=dlabels, breaks=drange)
p <- p + ggtitle('median CHL in NCRS by data product')
fn <- paste(outputDir, '/ts_NCRS_median.png', sep='')
ggsave(plot=p, filename=fn)

p <- ggplot(subset(df, region=='SCRS'), aes(x=date, y=chl, colour=product))
p <- p + geom_line() + geom_point()
p <- p + scale_x_date(labels=dlabels, breaks=drange)
p <- p + ggtitle('median CHL in SCRS by data product')
fn <- paste(outputDir, '/ts_SCRS_median.png', sep='')
ggsave(plot=p, filename=fn)

p <- ggplot(subset(df, region=='SRS'), aes(x=date, y=chl, colour=product))
p <- p + geom_line() + geom_point()
p <- p + scale_x_date(labels=dlabels, breaks=drange)
p <- p + ggtitle('median CHL in SRS by data product')
fn <- paste(outputDir, '/ts_SRS_median.png', sep='')
ggsave(plot=p, filename=fn)
