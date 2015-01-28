library(rasterVis)
library(ggplot2)

date_from_filename <- function(f) {
  b <- basename(f)
  b <- strsplit(b, '[.]')[[1]]
  b <- b[1]

  y <- substring(b, 2, 5)
  d <- as.numeric(substring(b, 6, 8))

  t <- as.Date(d - 1, origin=paste(y, '-01-01-', sep=''))
  return(t)
}

dir.create('derived/EDA/SST/weekly_maps/', recursive=TRUE)
load('data/common/shapefiles/red_sea_outside.Rdata')

FILE <- list.files('data/sst/clean', full.names=TRUE, pattern='*.grd')

for (f in FILE) {
  d <- date_from_filename(f)

  r <- raster(f)
  df <- as.data.frame(r, xy=TRUE)
  names(df) <- c('long', 'lat', 'layer')

  p <- ggplot() + geom_tile(aes(x=long, y=lat, fill=layer), data=df)
  p <- p + scale_fill_gradientn(colours=rev(brewer.pal(7, 'Spectral')),
                                            limits=c(15, 35),
                                name='SST')
  p <- p + coord_cartesian() 
  p <- p + geom_polygon(aes(x=long, y=lat, group=group), red.sea.outside,
                        fill='white', contour='black')
  p <- p + ggtitle(paste('SST around Arabia the week of the', d))

  fn <- paste('derived/EDA/SST/weekly_maps/', d, '.png', sep='')
  ggsave(fn, plot=p)
}