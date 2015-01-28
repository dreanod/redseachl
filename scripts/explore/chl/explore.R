library(raster)
library(ggplot2)

export_dir <- 'derived/EDA/CHL/hist_chl_arabia'
dir.create(export_dir, recursive=TRUE)

for(y in 2002:2014) {
  FILES <- list.files('data/chl/clean', full.names=TRUE,
                      pattern=paste('A', y, '.*.grd', sep=''))
  values = vector()

  for (f in FILES) {
    print(f)
    r <- raster(f)
    values <- c(values, as.vector(r))
  }
  p <- qplot(values) 
  p <- p + scale_x_log10(breaks=c(0.01,0.1,1,10,100), 
                         labels=c('0.01', '0.1', '1', '10', '100'))
  p <- p + xlab('CHL in mg/m^3')
  p <- p + ggtitle(paste('chl around Arabia in', y, '(MODIS)'))
  filename <- paste(export_dir, '/', y, '.png', sep='')

  ggsave(filename=filename, plot=p)
}