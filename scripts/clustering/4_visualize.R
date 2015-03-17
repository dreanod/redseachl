library(raster)
library(yaml)
library(R.matlab)
library(ggplot2)
library(RColorBrewer)
library(scales)

out_dir          <- 'results/plots/clusters'
chl_f            <- 'data/chl_oc_cci/aggregate/chl_oc_cci.grd'
red_sea_shape_f  <- 'data/common/shapefiles/red_sea_outside.Rdata'
raw_clusters_f   <- 'data/clustering/clusters_raw.mat'
clean_clusters_f <- 'data/clustering/clusters_clean.csv'
mask_f           <- 'data/chl_oc_cci/clustering/mask.Rdata'
config_f         <- 'scripts/load/config.yml'

dir.create(out_dir, recursive=TRUE)

load(red_sea_shape_f)
load(mask_f)

config <- yaml.load_file(config_f)
ext <- config$red_sea_extent
ext <- extent(ext$lon_min, ext$lon_max, ext$lat_min, ext$lat_max)

b <- brick(chl_f)
b <- crop(b, ext)
r <- raster(b, layer=1)

plot_map <- function(df, fn) {
  p <- ggplot(df, aes(x=long, y=lat, fill=labels))
  p <- p + geom_tile()
  p <- p + scale_colour_brewer(palette='Set2')
  p <- p + coord_fixed(xlim=c(32, 46), ylim=c(10,32))
  p <- p + geom_polygon(aes(x=long, y=lat, group=group),
                        red.sea.outside, colour='black',
                        fill='tan')
  p <- p + ylab('Latitude') + xlab('Longitude')
  ggsave(paste(out_dir, fn, sep='/'), plot=p)
}

DATA <- readMat(raw_clusters_f)
labels <- DATA$clusters

a <- as.matrix(r)
a[!mask] <- as.vector(labels)
values(r) <- a

df <- as.data.frame(r, xy=TRUE, na.rm=TRUE)
names(df) <- c('long', 'lat', 'labels')
df$labels <- as.factor(df$labels)

plot_map(df, 'clusters_raw.png')


df <- read.csv(clean_clusters_f)
df$labels <- as.factor(df$labels)
plot_map(df, 'clusters_clean.png')
