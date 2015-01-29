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
modis_r <- array(NA, c(dim(as.matrix(raster(FILES_MODIS[1]))), N))
modis_d <- NULL

t <- 0
for (i in 1:length(FILES_MODIS)) {
  f <- FILES_MODIS[i]
  print(f)
  
  d <- date_from_filename_modis(f)
  
  if (d >= date_start & d < date_end) {
    t <- t + 1
    r <- raster(f)
    modis_r[,,t] <- as.matrix(r)
    if (is.null(modis_d)) {
      modis_d <- d
    }
    else {
      modis_d <- c(modis_d, d)
    }
  }
}

cci_r <- array(NA, c(dim(as.matrix(raster(FILES_CCI[1]))), N))
cci_d <- NULL

t <- 0
for (i in 1:length(FILES_CCI)) {
  f <- FILES_CCI[i]
  print(f)

  d <- date_from_filename_cci(f)

  if (d >= date_start & d < date_end) {
    t <- t + 1
    r <- raster(f)
    cci_r[,,t] <- as.matrix(r)
    if (is.null(cci_d)) {
      cci_d <- d
    }
    else {
      cci_d <- c(cci_d, d)
    }
  }
}

diff_r <- cci_r[2:dim(cci_r)[1], 2:dim(cci_r)[2],] - modis_r
winter_r <- array(NA, c(dim(as.matrix(raster(FILES_MODIS[1]))), N / 2))
summer_r <- array(NA, c(dim(as.matrix(raster(FILES_MODIS[1]))), N / 2))
n_summer <- 0
n_winter <- 0

for (t in 1:length(cci_d)) {
  month <- as.numeric(format(cci_d[t], '%m'))
  if (month > 3 & month < 10) {
    n_summer <- n_summer + 1
    summer_r[,,n_summer] <- diff_r[,,t]
  }
  else {
    n_winter <- n_winter + 1
    winter_r[,,n_winter] <- diff_r[,,t]
  }
}

winter_m <- apply(winter_r, c(1,2), mean, na.rm=TRUE)
summer_m <- apply(summer_r, c(1,3), mean, na.rm=TRUE)

winter_r <- raster(FILES_CCI[1])
summer_r <- raster(FILES_CCI[1])

winter_r[,] <- winter_m
summer_r[,] <- summer_m

load('data/common/shapefiles/red_sea_outside.Rdata')

winter_df <- as.data.frame(winter_r, xy=TRUE)
names(winter_df) <- c('long', 'lat', 'chl')
p <- ggplot()
p <- p + geom_tile(aes(x=long, y=lat, fill=chl), data=winter_df)
p <- p + scale_fill_gradientn(colours=rev(brewer.pal(7, 'RdBu')),
                          limits=c(-10, 10), trans='log', oob=squish,
                          name='chl (mg/m^3)', breaks=c(-10, -1, 0, 1, 10),
                          labels=as.character(c(-10, -1, 0, 1, 10)))
p <- p + coord_cartesian()
p <- p + geom_polygon(aes(x=long, y=lat, group=group), red.sea.outside,
                      fill='white', contour='black')
p <- p + ggtitle('yearly CHL average (MODIS 2002-2014)')
