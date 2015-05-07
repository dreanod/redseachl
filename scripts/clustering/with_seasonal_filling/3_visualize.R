library(raster)
library(R.matlab)
library(ggplot2)
library(RColorBrewer)
library(scales)

out_dir          <- 'derived/clustering/with_seasonal_filling'
chl_f            <- 'data/chl_oc_cci/filled/seasonal_filling/chl_filled.grd'
red_sea_shape_f  <- 'data/common/shapefiles/red_sea_outside.Rdata'
raw_clusters_f   <- paste(out_dir, 'clusters.mat', sep='/')
clean_clusters_f <- 'derived/clustering/with_seasonal_filling/clusters.csv'
mask_f           <- 'data/chl_oc_cci/filled/seasonal_filling/mask.mat'

dir.create(out_dir, recursive=TRUE)

load(red_sea_shape_f)

mask <- readMat(mask_f)$mask
mask <- mask == 1

b <- brick(chl_f)
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
labels[labels == -1] <- NA
values(r) <- labels

df <- as.data.frame(r, xy=TRUE, na.rm=TRUE)
names(df) <- c('long', 'lat', 'labels')
df$labels <- as.factor(df$labels)

plot_map(df, 'clusters_raw.png')


df <- read.csv(clean_clusters_f)
df$labels <- as.factor(df$labels)
plot_map(df, 'clusters_clean.png')
