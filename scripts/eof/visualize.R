library(raster)
library(ggplot2)
library(RColorBrewer)

load('data/common/shapefiles/red_sea_outside.Rdata')

plot_eof <- function(r, fn, xmn, xmx, ymn, ymx) {
  df <- as.data.frame(r, xy=TRUE, na.rm=TRUE)
  names(df) <- c('long', 'lat', 'layer')

  p <- ggplot() + geom_tile(aes(x=long, y=lat, fill=layer), data=df)
  p <- p + scale_fill_gradientn(colours=rev(brewer.pal(7, 'Spectral')),
                                name='chl (mg/m^3)')
  p <- p + coord_cartesian(xlim=c(xmn, xmx), ylim=c(ymn, ymx))
  p <- p + geom_polygon(aes(x=long, y=lat, group=group), red.sea.outside,
                        fill='white', contour='black')
  ggsave(fn, plot=p)
}

outDir <- 'derived/eof/chl_clusters_eof'

r <- raster(paste(outDir, 'eof_1.1.grd', sep='/'))
fn <- paste(outDir, 'eof_1.1.png', sep='/')
plot_eof(r, fn, xmn=35, xmx=45, ymn=12, ymx=20)

r <- raster(paste(outDir, 'eof_1.2.grd', sep='/'))
fn <- paste(outDir, 'eof_1.2.png', sep='/')
plot_eof(r, fn, xmn=35, xmx=45, ymn=12, ymx=20)

r <- raster(paste(outDir, 'eof_2.1.grd', sep='/'))
fn <- paste(outDir, 'eof_2.1.png', sep='/')
plot_eof(r, fn, xmn=36, xmx=42, ymn=16, ymx=25)

r <- raster(paste(outDir, 'eof_2.2.grd', sep='/'))
fn <- paste(outDir, 'eof_2.2.png', sep='/')
plot_eof(r, fn, xmn=36, xmx=42, ymn=16, ymx=25)

r <- raster(paste(outDir, 'eof_3.1.grd', sep='/'))
fn <- paste(outDir, 'eof_3.1.png', sep='/')
plot_eof(r, fn, xmn=35, xmx=40, ymn=21, ymx=26)

r <- raster(paste(outDir, 'eof_3.2.grd', sep='/'))
fn <- paste(outDir, 'eof_3.2.png', sep='/')
plot_eof(r, fn, xmn=35, xmx=40, ymn=21, ymx=26)

r <- raster(paste(outDir, 'eof_4.1.grd', sep='/'))
fn <- paste(outDir, 'eof_4.1.png', sep='/')
plot_eof(r, fn, xmn=33, xmx=37, ymn=23, ymx=28)

r <- raster(paste(outDir, 'eof_4.2.grd', sep='/'))
fn <- paste(outDir, 'eof_4.2.png', sep='/')
plot_eof(r, fn, xmn=33, xmx=37, ymn=23, ymx=28)