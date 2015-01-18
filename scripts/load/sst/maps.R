library(rasterVis)

dir.create('derived/EDA/SST/weekly_maps/', recursive=TRUE)

FILE <- list.files('data/sst/clean', full.names=TRUE)

for (f in FILE[1:2]) {
  r <- raster(f)
  df <- as.data.frame(r, xy=TRUE)

  p <- ggplot(df, aes(x=x, y=y, fill=layer)) + geom_tile()
  p <- p + scale_fill_gradientn(colours=rev(brewer.pal(7, 'Spectral')),
                                            limits=c(15, 35))
  p <- p + coord_cartesian()

  ggsave(filename=paste('derived/EDA/SST/weekly_maps/', basename(f), '.png', sep=''), plot=p)
}