library(rasterVis)
library(ggplot2)

date_from_filename <- function(f) {
  b <- basename(f)
  b <- splitstr(b, sep='.')[[1]]
  b <- b[1]

  y <- substring(b, 2, 5)
  d <- substring(b, 6, 8)

  t <- as.Date(paste('01-01-', y, sep='')) + d - 1
  return(t)
}

dir.create('derived/EDA/SST/weekly_maps/', recursive=TRUE)
load('data/common/shapefiles/red_sea_outside.Rdata')

FILE <- list.files('data/sst/clean', full.names=TRUE)

for (f in FILE[1:2]) {
  r <- raster(f)
  df <- as.data.frame(r, xy=TRUE)
  names(df) <- c('long', 'lat', 'layer')

  p <- ggplot() + geom_tile(aes(x=long, y=lat, fill=layer), data=df)
  p <- p + scale_fill_gradientn(colours=rev(brewer.pal(7, 'Spectral')),
                                            limits=c(15, 35))
  p <- p + coord_cartesian() 
  p <- p + geom_polygon(aes(x=long, y=lat, group=group), red.sea.outside,
                        fill='white', contour='black', size=50)
  p <- p + legend('SST')

  ggsave(filename=paste('derived/EDA/SST/weekly_maps/', basename(f), '.png', sep=''), plot=p)
}