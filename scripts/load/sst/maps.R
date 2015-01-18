library(rasterVis)
library(ggplot2)

dir.create('derived/EDA/SST/weekly_maps/', recursive=TRUE)
load('data/common/shapefiles/red_sea_outside.Rdata')

FILE <- list.files('data/sst/clean', full.names=TRUE)

for (f in FILE) {
  r <- raster(f)
  df <- as.data.frame(r, xy=TRUE)
  names(df) <- c('long', 'lat', 'layer')

  p <- ggplot() + geom_tile(aes(x=long, y=lat, fill=layer), data=df)
  p <- p + scale_fill_gradientn(colours=rev(brewer.pal(7, 'Spectral')),
                                            limits=c(15, 35))
  p <- p + coord_cartesian() 
  p <- p + geom_polygon(aes(x=long, y=lat, group=group), red.sea.outside,
                        fill='white', contour='tan', size=5)

  ggsave(filename=paste('derived/EDA/SST/weekly_maps/', basename(f), '.png', sep=''), plot=p)
}