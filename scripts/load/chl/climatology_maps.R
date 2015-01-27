library(raster)
library(scales)
library(ggplot2)
library(RColorBrewer)

FILES <- list.files('data/chl/clean/', pattern='*.grd', full.names=TRUE)

outputDir <- 'derived/EDA/CHL/climatology_maps'
dir.create(outputDir, recursive=TRUE)

m <- as.matrix(raster(FILES[1]))
m <- array(NA, c(dim(m), length(FILES)))

for (i in 1:length(FILES)) {
  print(FILES[i])
  r <- raster(FILES[i])
  m[,,i] <- as.matrix(r)
}

clim <- apply(m, c(1,2), mean, na.rm=TRUE)
r <- raster(FILES[1])
r[,] <- clim

df <- as.data.frame(r, xy=TRUE)
names(df) <- c('long', 'lat', 'chl')

load('data/common/shapefiles/red_sea_outside.Rdata')

p <- ggplot()
p <- p + geom_tile(aes(x=long, y=lat, fill=chl), data=df)
p <- p + scale_fill_gradientn(colours=rev(brewer.pal(7, 'Spectral')),
                          limits=c(0.05, 10), trans='log', oob=squish,
                          name='chl (mg/m^3)', breaks=c(0.1, 1, 10),
                          labels=as.character(c(0.1, 1, 10)))
p <- p + coord_cartesian()
p <- p + geom_polygon(aes(x=long, y=lat, group=group), red.sea.outside,
                      fill='white', contour='black')
p <- p + ggtitle('yearly CHL average (MODIS 2002-2014)')

fn <- paste(outputDir, '/yearly_average.png', sep='')
ggsave(fn, plot=p)


# Seasonal climatologies
date_from_filename <- function(f) {
  b <- basename(f)
  b <- strsplit(b, '[.]')[[1]]
  b <- b[1]

  y <- substring(b, 2, 5)
  d <- as.numeric(substring(b, 6, 8))

  t <- as.Date(d - 1, origin=paste(y, '-01-01-', sep=''))
  return(t)
}

m <- as.matrix(raster(FILES[1]))
m_winter <- array(NA, c(dim(m), length(FILES)))
m_summer <- array(NA, c(dim(m), length(FILES)))

for (i in 1:length(FILES)) {
  f <- FILES[i]
  print(f)
  r <- raster(f)
  d <- date_from_filename(f)
  month <- as.numeric(format(d, '%m'))
  if (month > 3 & month < 10) {
    m_summer[,,i] <- as.matrix(r)
  }
  else {
    m_winter[,,i] <- as.matrix(r)
  }
}

r_summer <- raster(FILES[1])
clim_summer <- apply(m_summer, c(1,2), mean, na.rm=TRUE)
r_summer[,] <- clim_summer

r_winter <- raster(FILES[1])
clim_winter <- apply(m_winter, c(1,2), mean, na.rm=TRUE)
r_winter[,] <- clim_winter

df <- as.data.frame(r_winter, xy=TRUE)
names(df) <- c('long', 'lat', 'chl')

p <- ggplot()
p <- p + geom_tile(aes(x=long, y=lat, fill=chl), data=df)
p <- p + scale_fill_gradientn(colours=rev(brewer.pal(7, 'Spectral')),
                          limits=c(0.05, 10), trans='log', oob=squish,
                          name='chl (mg/m^3)', breaks=c(0.1, 1, 10),
                          labels=as.character(c(0.1, 1, 10)))
p <- p + coord_cartesian()
p <- p + geom_polygon(aes(x=long, y=lat, group=group), red.sea.outside,
                      fill='white', contour='black')
p <- p + ggtitle('winter CHL average (MODIS 2002-2014)')

fn <- paste(outputDir, '/winter_average.png', sep='')
ggsave(fn, plot=p)

df <- as.data.frame(r_summer, xy=TRUE)
names(df) <- c('long', 'lat', 'chl')

p <- ggplot()
p <- p + geom_tile(aes(x=long, y=lat, fill=chl), data=df)
p <- p + scale_fill_gradientn(colours=rev(brewer.pal(7, 'Spectral')),
                          limits=c(0.05, 10), trans='log', oob=squish,
                          name='chl (mg/m^3)', breaks=c(0.1, 1, 10),
                          labels=as.character(c(0.1, 1, 10)))
p <- p + coord_cartesian()
p <- p + geom_polygon(aes(x=long, y=lat, group=group), red.sea.outside,
                      fill='white', contour='black')
p <- p + ggtitle('summer CHL average (MODIS 2002-2014)')

fn <- paste(outputDir, '/summer_average.png', sep='')
ggsave(fn, plot=p)

