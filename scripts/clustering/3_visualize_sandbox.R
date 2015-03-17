library(raster)

b <- brick('data/chl_oc_cci/aggregate/chl_oc_cci.grd')
library(yaml)
config <- yaml.load_file('scripts/load/config.yml')
ext <- config$red_sea_extent
ext <- extent(ext$lon_min, ext$lon_max, ext$lat_min, ext$lat_max)
b <- crop(b, ext)

library(R.matlab)
DATA <- readMat('derived/clustering/gmm_full_4_clusters_seasonal_reduced.mat')
labels <- DATA$clusters
load('data/chl_oc_cci/clustering/mask.Rdata')

r <- raster(b, layer=1)

a <- as.matrix(r)
a[!mask] <- as.vector(labels)
values(r) <- a

df <- as.data.frame(r, xy=TRUE, na.rm=TRUE)
names(df) <- c('long', 'lat', 'labels')
df$labels <- as.factor(df$labels)

load('data/common/shapefiles/red_sea_outside.Rdata')

library(ggplot2)
library(RColorBrewer)
library(scales)

p <- ggplot(df, aes(x=long, y=lat, fill=labels))
p <- p + geom_tile()
p <- p + scale_colour_brewer(palette='Set2')
p <- p + coord_fixed(xlim=c(32, 46), ylim=c(10,32))
p <- p + geom_polygon(aes(x=long, y=lat, group=group),
                      red.sea.outside, colour='black',
                      fill='tan')
p <- p + ylab('Latitude') + xlab('Longitude')
ggsave('derived/clustering/gmm_full_4_clusters_seasonal_reduced.png', plot=p)


