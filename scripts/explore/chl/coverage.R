library(RColorBrewer)
library(raster)
library(ggplot2)

output_dir <- 'derived/EDA/chl/missing_values'
dir.create(output_dir, recursive=TRUE)

FILES <- list.files('data/chl/clean', pattern='*.grd', full.names=TRUE)
N <- length(FILES)

s <- matrix(0, 720, 960)

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
p <- p + ggtitle('% of chl missing values between 2002 and 2014')
ggsave(paste(output_dir, '/map_total.png', sep=''), p)

## Climatological coverage (Winter and Summer)
date_from_filename <- function(f) {
  b <- basename(f)
  b <- strsplit(b, '[.]')[[1]]
  b <- b[1]

  y <- substring(b, 2, 5)
  d <- as.numeric(substring(b, 6, 8))

  t <- as.Date(d - 1, origin=paste(y, '-01-01-', sep=''))
  return(t)
}

s_winter <- matrix(0, 720, 960)
s_summer <- matrix(0, 720, 960)
n_winter <- 0
n_summer <- 0

for (f in FILES) {
  r <- raster(f)
  r <- as.matrix(r)

  d <- date_from_filename(f)
  month <- as.numeric(format(d, '%m'))
  
  if (month >3 & month < 10) { 
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
p <- p + ggtitle('% of chl missing values between 2002 and 2014 during winter')
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
p <- p + ggtitle('% of chl missing values between 2002 and 2014 during summer')
ggsave(paste(outputDir, '/map_summer.png', sep=''), p)
