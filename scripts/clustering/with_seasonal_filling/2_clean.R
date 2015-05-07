library(raster)

b <- brick('data/chl_oc_cci/aggregate/chl_oc_cci.grd')
library(yaml)
config <- yaml.load_file('scripts/load/config.yml')
ext <- config$red_sea_extent
ext <- extent(ext$lon_min, ext$lon_max, ext$lat_min, ext$lat_max)
b <- crop(b, ext)

library(R.matlab)
DATA <- readMat('derived/clustering/with_seasonal_filling/clusters.mat')
labels <- DATA$clusters

r <- raster(b, layer=1)
labels[labels < 1] <- NA
values(r) <- labels

df <- as.data.frame(r, xy=TRUE, na.rm=TRUE)
names(df) <- c('long', 'lat', 'labels')
df$labels <- as.factor(df$labels)

df <- subset(df, (labels == 1 & lat < 20) |
                 (labels == 2 & lat < 22) |
                 (labels == 3 & lat < 26) |
                 (labels == 4 & lat < 28))
values(r) <- NA
r[cellFromXY(r, df[1:2])] <- df$labels
write.csv(df, file='derived/clustering/with_seasonal_filling/clusters.csv')
writeRaster(r, 'derived/clustering/with_seasonal_filling/clusters.grd',
            overwrite=TRUE)