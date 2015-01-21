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