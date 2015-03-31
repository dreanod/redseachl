library(ggplot2)
library(raster)
library(yaml)
library(ggplot2)
library(RColorBrewer)
library(scales)

config_f <- 'scripts/load/config.yml'
chl_cci_incomplete_f <- 'data/chl_oc_cci/aggregate/chl_oc_cci.grd'
chl_cci_filled_f <- 'data/chl_oc_cci/filled/seasonal_filling/chl_filled.grd'
resultsDir <- 'results/data_filling/chl_oc_cci_seasonal_filling'

plot_red_sea <- function(r, fn, cmin=0.05, cmax=10, breaks=c(0.1, 1, 10)) {
  load('data/common/shapefiles/red_sea_outside.Rdata')
  df <- as.data.frame(r, xy=TRUE)
  names(df) <- c('long', 'lat', 'chl')

  p <- ggplot() + geom_tile(aes(x=long, y=lat, fill=chl), data=df)
  p <- p + scale_fill_gradientn(colours=rev(brewer.pal(7, 'Spectral')),
                                limits=c(cmin, cmax), trans='log',
                                name='chl (mg/m^3)', breaks=breaks,
                                labels=as.character(breaks))
  p <- p + coord_cartesian()
  p <- p + geom_polygon(aes(x=long, y=lat, group=group), red.sea.outside,
                    fill='white', contour='black')
  p <- p + ggtitle('no title')
  ggsave(fn, plot=p)
}

dir.create(resultsDir, recursive=TRUE)

config <- yaml.load_file(config_f)
ext <- config$red_sea_extent
ext <- extent(c(ext$lon_min, ext$lon_max, ext$lat_min, ext$lat_max))

chl_incomplete <- brick(chl_cci_incomplete_f)
chl_incomplete <- crop(chl_incomplete, ext)
chl_incomplete <- dropLayer(chl_incomplete, c(1,2)) # fist two layers are empty

chl_filled <- brick(chl_cci_filled_f)

# 1998-05-09 / CCI incomplete
r <- raster(chl_incomplete, layer=33)
fn <- paste(resultsDir, '1998-05-09_cci_original.png', sep='/')
plot_red_sea(r, fn, cmin=0.05, cmax=10, breaks=c(0.1, 1, 10))

# 1998-05-09 / CCI filled
r <- raster(chl_filled, layer=33)
fn <- paste(resultsDir, '1998-05-09_cci_filled.png', sep='/')
plot_red_sea(r, fn, cmin=0.05, cmax=10, breaks=c(0.1, 1, 10))

# 2000-04-06 / CCI incomplete
r <- raster(chl_incomplete, layer=89)
fn <- paste(resultsDir, '2000-04-06_cci_original.png', sep='/')
plot_red_sea(r, fn, cmin=0.05, cmax=10, breaks=c(0.1, 1, 10))

# 2000-04-06 / CCI filled
r <- raster(chl_filled, layer=89)
fn <- paste(resultsDir, '2000-04-06_cci_filled.png', sep='/')
plot_red_sea(r, fn, cmin=0.05, cmax=10, breaks=c(0.1, 1, 10))
