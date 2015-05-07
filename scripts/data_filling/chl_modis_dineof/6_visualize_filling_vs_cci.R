library(ggplot2)
library(R.matlab)
library(raster)
library(yaml)
library(ggplot2)
library(RColorBrewer)
library(scales)

config_f <- 'scripts/load/config.yml'
chl_modis_incomplete_f <- 'data/chl/aggregate/chl.grd'
chl_cci_f <- 'data/chl_oc_cci/aggregate/chl_oc_cci.grd'
chl_modis_filled_f <- 'data/chl/aggregate/chl.grd'
chl_filling_values_f <- 'data/filled_data/chl_modis/chl.mat'
mask_f <- 'data/filled_data/chl_modis/mask.mat'
resultsDir <- 'results/data_filling'

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

chl_modis_incomplete <- brick(chl_modis_incomplete_f)
chl_modis_incomplete <- crop(chl_modis_incomplete, ext)

chl_cci <- brick(chl_cci_f)
chl_cci <- crop(chl_cci, ext)

chl_modis_filled <- brick(chl_modis_filled_f)
chl_modis_filled <- crop(chl_modis_filled, ext)

chl_filling_values <- readMat(chl_filling_values_f)$chl.filled
mask <- readMat(mask_f)$mask
mask <- mask == 1
for (i in 1:dim(chl_filling_values)[3]) {
  chl_tmp <- chl_filling_values[,,i]
  chl_tmp[mask] <- NA
  chl_filling_values[,,i] <- chl_tmp
}
values(chl_modis_filled) <- chl_filling_values

# 2004-05-16 / MODIS original
r <- raster(chl_modis_incomplete, layer=87)
fn <- paste(resultsDir, '2004-05-16_modis_original.png', sep='/')
plot_red_sea(r, fn, cmin=0.08, cmax=5, breaks=c(0.08, 0.2, 5))

# 2004-05-16 / MODIS filled
r <- raster(chl_modis_filled, layer=87)
fn <- paste(resultsDir, '2004-05-16_modis_filled.png', sep='/')
plot_red_sea(r, fn, cmin=0.08, cmax=5, breaks=c(0.08, 0.2, 5))

# 2004-05-16 / CCI
r <- raster(chl_cci, layer=310)
fn <- paste(resultsDir, '2004-05-16_cci.png', sep='/')
plot_red_sea(r, fn, cmin=0.08, cmax=20, breaks=c(0.08, 1, 20))

# 2008-07-19 / MODIS original
r <- raster(chl_modis_incomplete, layer=279)
fn <- paste(resultsDir, '2008-07-19_modis_original.png', sep='/')
plot_red_sea(r, fn, cmin=0.05, cmax=1, breaks=c(0.05, 0.2, 1))

# 2008-07-19 / MODIS filled
r <- raster(chl_modis_filled, layer=279)
fn <- paste(resultsDir, '2008-07-19_modis_filled.png', sep='/')
plot_red_sea(r, fn, cmin=0.05, cmax=1, breaks=c(0.05, 0.2, 1))

# 2008-07-19 / CCI
r <- raster(chl_cci, layer=502)
fn <- paste(resultsDir, '2008-07-19_cci.png', sep='/')
plot_red_sea(r, fn, cmin=0.08, cmax=20, breaks=c(0.08, 1, 20))
