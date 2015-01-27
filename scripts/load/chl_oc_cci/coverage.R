library(RColorBrewer)
library(raster)
library(ggplot2)
library(scales)

outputDir <- 'derived/EDA/chl_oc_cci/missing_values'
dir.create(outputDir, recursive=TRUE)

FILES <- list.files('data/chl_oc_cci/clean', pattern='*.grd',
                    full.names=TRUE)
N <- length(FILES)

s <- array(0, dim(as.matrix(raster(FILES[1]))))

for (f in FILES) {
  print(f)
  r <- as.matrix(raster(f))
  s <- s + is.na(r)
}

s <- s / N * 100
r <- raster(FILES[1])
r[,] <- s

df <- as.data.frame(r, xy=TRUE)
names(df) <- c('long', 'lat', 'missing')
load('data/common/shapefiles/red_sea_outside.Rdata')

p <- ggplot()
p <- p + geom_tile(aes(x=long, y=lat, fill=missing), df)
p <- p + scale_fill_gradientn(colours=rev(brewer.pal(7, 'Spectral')),
                              breaks=seq(0, 100, 20),
                              labels=as.character(seq(0, 100, 20)),
                              name='%')
p <- p + coord_cartesian()
p <- p + geom_polygon(aes(x=long, y=lat, group=group), red.sea.outside,
                      fill='white', contour='black')
p <- p + ggtitle('% of chl missing values between 1997 and 2012 (OC_CCI)')
ggsave(paste(outputDir, '/map_total.png', sep=''), p)

## Climatological coverage (winter and summer)
date_from_filename <- function(f) {
  b <- basename(f)
  b <- strsplit(b, '[.]')[[1]]
  b <- b[1]

  return(as.Date(b))
}

s_winter <- array(0, dim(as.matrix(raster(FILES[1]))))
s_summer <- array(0, dim(as.matrix(raster(FILES[1]))))
n_winter <- 0
n_summer <- 0

for (f in FILES) {
  r <- raster(f)
  r <- as.matrix(r)

  d <- date_from_filename(f)
  month <- as.numeric(format(d, '%m'))

  if (month > 3 & month < 10) {
    s_summer <- s_summer + is.na(r)
    n_summer <- n_summer + 1
  }
  else {
    s_winter <- s_winter + is.na(r)
    n_winter <- n_winter + 1
  }
}

r_winter <- raster(f)
r_summer <- raster(f)

r_summer[,] <- s_summer / n_summer * 100
r_winter[,] <- s_winter / n_winter * 100

df <- as.data.frame(r_winter, xy=TRUE)
names(df) <- c('long', 'lat', 'missing')
load('data/common/shapefiles/red_sea_outside.Rdata')

p <- ggplot()
p <- p + geom_tile(aes(x=long, y=lat, fill=missing), df)
p <- p + scale_fill_gradientn(colours=rev(brewer.pal(7, 'Spectral')),
                              breaks=seq(0, 100, 20),
                              labels=as.character(seq(0, 100, 20)),
                              name='%')
p <- p + coord_cartesian()
p <- p + geom_polygon(aes(x=long, y=lat, group=group), red.sea.outside,
                      fill='white', contour='black')
p <- p + ggtitle('% of chl missing values between 1997 and 2012 during winter (OC-CCI)')
ggsave(paste(outputDir, '/map_winter.png', sep=''), p)

df <- as.data.frame(r_summer, xy=TRUE)
names(df) <- c('long', 'lat', 'missing')

p <- ggplot()
p <- p + geom_tile(aes(x=long, y=lat, fill=missing), df)
p <- p + scale_fill_gradientn(colours=rev(brewer.pal(7, 'Spectral')),
                              breaks=seq(0, 100, 20),
                              labels=as.character(seq(0, 100, 20)),
                              name='%')
p <- p + coord_cartesian()
p <- p + geom_polygon(aes(x=long, y=lat, group=group), red.sea.outside,
                      fill='white', contour='black')
p <- p + ggtitle('% of chl missing values between 1997 and 2012 during summer (OC-CCI)')
ggsave(paste(outputDir, '/map_summer.png', sep=''), p)
