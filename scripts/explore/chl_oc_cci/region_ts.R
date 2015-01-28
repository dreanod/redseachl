library(raster)
library(ggplot2)
library(yaml)

date_from_filename <- function(f) {
  b <- basename(f)
  b <- strsplit(b, '[.]')[[1]]
  b <- b[1]
  return(as.Date(b))
}

config <- yaml.load_file('scripts/load/config.yml')
NRS <- config$NRS
NRS <- extent(c(NRS$lon_min, NRS$lon_max, NRS$lat_min, NRS$lat_max))
NCRS <- config$NCRS
NCRS <- extent(c(NCRS$lon_min, NCRS$lon_max, NCRS$lat_min, NCRS$lat_max))
SCRS <- config$SCRS
SCRS <- extent(c(SCRS$lon_min, SCRS$lon_max, SCRS$lat_min, SCRS$lat_max))
SRS <- config$SRS
SRS <- extent(c(SRS$lon_min, SRS$lon_max, SRS$lat_min, SRS$lat_max))

outputDir <- 'derived/EDA/chl_oc_cci/regional_averages'
dir.create(outputDir, recursive=TRUE)

FILES <- list.files('data/chl_oc_cci/clean', full.names=TRUE, 
                    pattern='*.grd')

v_nrs <- vector()
v_ncrs <- vector()
v_scrs <- vector()
v_srs <- vector()
d <- NULL

for (f in FILES) {
  print(f)
  if (is.null(d)) {
    d <- date_from_filename(f)
  }
  else {
    d <- c(d, date_from_filename(f))
  }
  r <- raster(f)

  r_nrs <- crop(r, NRS)
  r_ncrs <- crop(r, NCRS)
  r_scrs <- crop(r, SCRS)
  r_srs <- crop(r, SRS)

  v_nrs <- c(v_nrs, mean(r_nrs[,], na.rm=TRUE))
  v_ncrs <- c(v_ncrs, mean(r_ncrs[,], na.rm=TRUE))
  v_scrs <- c(v_scrs, mean(r_scrs[,], na.rm=TRUE))
  v_srs <- c(v_srs, mean(r_srs[,], na.rm=TRUE))
}

df <- data.frame(date=d, NRS=v_nrs, NCRS=v_ncrs, SCRS=v_scrs, SRS=v_srs)

p <- ggplot(data=df, aes(x=date, y=NRS))
p <- p + geom_line()
p <- p + ylab('CHL (mg/m^3)')
p <- p + ggtitle('CHL average over NRS (OC-CCI)')
fn <- paste(outputDir, '/nrs_average.png', sep='')
ggsave(fn, plot=p, width=25, height=7, units='cm')

p <- ggplot(data=df, aes(x=date, y=NCRS))
p <- p + geom_line()
p <- p + ylab('CHL (mg/m^3)')
p <- p + ggtitle('CHL average over NCRS (OC-CCI)')
fn <- paste(outputDir, '/ncrs_average.png', sep='')
ggsave(fn, plot=p, width=25, height=7, units='cm')

p <- ggplot(data=df, aes(x=date, y=SCRS))
p <- p + geom_line()
p <- p + ylab('CHL (mg/m^3)')
p <- p + ggtitle('CHL average over SCRS (OC-CCI)')
fn <- paste(outputDir, '/scrs_average.png', sep='')
ggsave(fn, plot=p, width=25, height=7, units='cm')

p <- ggplot(data=df, aes(x=date, y=SRS))
p <- p + geom_line()
p <- p + ylab('CHL (mg/m^3)')
p <- p + ggtitle('CHL average over SRS (OC-CCI)')
fn <- paste(outputDir, '/srs_average.png', sep='')
ggsave(fn, plot=p, width=25, height=7, units='cm')
