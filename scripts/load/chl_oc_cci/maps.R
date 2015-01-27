library(raster)
library(ggplot2)
library(RColorBrewer)
library(scales)

date_from_filename <- function(f) {
  b <- basename(f)
  b <- strsplit(b, '[.]')[[1]]
  b <- b[1]

  return(as.Date(b))
}

outputDir <- 'derived/EDA/chl_oc_cci/weekly_maps/'
dir.create(outputDir, recursive=TRUE)

load('data/common/shapefiles/red_sea_outside.Rdata')

FILES <- list.files('data/chl_oc_cci/clean', full.names=TRUE,
                    pattern='*.grd')

for (f in FILES) {
  d <- date_from_filename(f)
  r <- raster(f)
  df <- as.data.frame(r, xy=TRUE)
  names(df) <- c('long', 'lat', 'chl')

  p <- ggplot() + geom_tile(aes(x=long, y=lat, fill=chl), data=df)
  p <- p + scale_fill_gradientn(colours=rev(brewer.pal(7, 'Spectral')),
                                limits=c(0.05, 10), trans='log',
                                name='chl (mg/m^3)', breaks=c(0.1, 1, 10),
                                labels=c('0.1', '1', '10'))
  p <- p + coord_cartesian()
  p <- p + geom_polygon(aes(x=long, y=lat, group=group), red.sea.outside,
                    fill='white', contour='black')
  p <- p + ggtitle(paste('CHL around Arabian the week of the', d, 
                         '(OC-CCI)'))
  fn <- paste(outputDir, '/', d, '.png', sep='')
  ggsave(fn, plot=p)
}