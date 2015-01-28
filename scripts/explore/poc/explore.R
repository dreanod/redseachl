library(raster)
library(ggplot2)

dir.create('derived/EDA/poc/hist_poc_arabia', recursive=TRUE)

for (y in 2002:2014) {
  FILES <- list.files('data/poc/clean', full.names=TRUE, 
                      pattern=paste('A', y ,'.*.grd', sep=''))
  values = vector()

  for (f in FILES) {
    print(f)
    r <- raster(f)
    values = c(values, as.vector(r))
  }
  p <- qplot(values) + xlab('POC (mg/m^3)')
  p <- p + scale_x_log10(breaks=c(1e1,1e2,1e3,1e4),
                         labels=c('10','100','1000','10000'))
  p <- p + ggtitle(paste('POC around Arabia in', y))
  filename <- paste('derived/EDA/poc/hist_poc_arabia/', y, '.png', sep='')
  ggsave(filename=filename, plot = p)
}
