library(raster)
library(ggplot2)

outputDir <- 'derived/EDA/chl_oc_cci/hist_chl_arabia'
dir.create(outputDir, recursive=TRUE)

for (y in 1997:2012) {
  FILES <- list.files('data/chl_oc_cci/clean', full.names=TRUE,
                      pattern=paste(y, '.*.grd', sep=''))

  values = vector()

  for (f in FILES) {
    print(f)
    r <- raster(f)
    values <- c(values, as.vector(r))
  }
  p <- qplot(values)
  p <- p + scale_x_log10(breaks=c(0.01, 0.1, 1, 10, 100),
                         labels=as.character(c(0.01, 0.1, 1, 10, 100)))
  p <- p + xlab('CHL in mg/m^3')
  p <- p + ggtitle(paste('chl around Arabia in', y, '(OC-CCI)'))
  fn <- paste(outputDir, '/', y, '.png', sep='')

  ggsave(filename=fn, plot=p)
}