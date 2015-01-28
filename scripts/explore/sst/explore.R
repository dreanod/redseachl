library(raster)
library(ggplot2)

dir.create('derived/EDA/SST/SST_around_Arabia', recursive=TRUE)

for (y in 2002:2014) {
  FILES <- list.files('data/sst/clean', full.names=TRUE, 
                      pattern=paste('A', y ,'.*.grd', sep=''))
  values = vector()

  for (f in FILES) {
    print(f)
    r <- raster(f)
    values = c(values, as.vector(r))
  }
  p <- qplot(values) + xlab('SST in Celsius') 
  p <- p + ggtitle(paste('SST around Arabia in', y))
  filename <- paste('derived/EDA/SST/SST_around_arabia/', y, '.png', sep='')
  ggsave(filename=filename, plot = p)
}