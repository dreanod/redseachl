library(raster)
library(ggplot2)

dir.create('derived/EDA/par/hist_par_arabia', recursive=TRUE)

for (y in 2002:2014) {
  FILES <- list.files('data/par/clean', full.names=TRUE,
                      pattern=paste('A', y, '.*.grd', sep=''))

  values = vector()

  for (f in FILES) {
    print(f)
    r <- raster(f)
    values <- c(values, as.vector(r))
  }
  p <- qplot(values) + xlab('PAR in Einstein/m^2.day')
  p <- p + ggtitle(paste('PAR around Arabia in', y))
  fn <- paste('derived/EDA/par/hist_par_arabia/', y, '.png', sep='')

  ggsave(filename=fn, plot=p)
}