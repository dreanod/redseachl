library(raster)
library(ggplot2)

dir.create('derived/EDA/cdom/hist_cdom_arabia', recursive=TRUE)

for (y in 2002:2014) {
  FILES <- list.files('data/cdom/clean', full.names=TRUE, 
                      pattern=paste('A', y ,'.*.grd', sep=''))
  values = vector()

  for (f in FILES) {
    print(f)
    r <- raster(f)
    values = c(values, as.vector(r))
  }
  p <- qplot(values) + xlab('CDOM index') 
  p <- p + ggtitle(paste('CDOM around Arabia in', y))
  filename <- paste('derived/EDA/cdom/hist_cdom_arabia/', y, '.png', sep='')
  ggsave(filename=filename, plot = p)
}
