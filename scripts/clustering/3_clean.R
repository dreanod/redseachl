library(raster)

b <- brick('data/chl_oc_cci/aggregate/chl_oc_cci.grd')
library(yaml)
config <- yaml.load_file('scripts/load/config.yml')
ext <- config$red_sea_extent
ext <- extent(ext$lon_min, ext$lon_max, ext$lat_min, ext$lat_max)
b <- crop(b, ext)

library(R.matlab)
DATA <- readMat('data/clustering/clusters_raw.mat')
labels <- DATA$clusters
load('data/chl_oc_cci/clustering/mask.Rdata')

r <- raster(b, layer=1)

a <- as.matrix(r)
a[!mask] <- as.vector(labels)
values(r) <- a

df <- as.data.frame(r, xy=TRUE, na.rm=TRUE)
names(df) <- c('long', 'lat', 'labels')
df$labels <- as.factor(df$labels)

df <- subset(df, (labels == 1 & lat < 20) |
                 (labels == 2 & lat < 22) |
                 (labels == 3 & lat < 26) |
                 (labels == 4 & lat < 28))

write.csv(df, file='data/clustering/clusters_clean.csv')