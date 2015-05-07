library(RColorBrewer)
library(raster)
library(ggplot2)
library(scales)
library(yaml)

config <- yaml.load_file('scripts/load/config.yml')
ext <- config$red_sea_extent
ext <- extent(c(ext$lon_min, ext$lon_max, ext$lat_min, ext$lat_max))

outputDir <- 'results/proposal/figures'
dir.create(outputDir, recursive=TRUE)

FILES <- list.files('data/chl_oc_cci/clean', pattern='*.grd',
                    full.names=TRUE)
N <- length(FILES)

date_from_filename <- function(f) {
  b <- basename(f)
  b <- strsplit(b, '[.]')[[1]]
  b <- b[1]

  return(as.Date(b))
}

s_summer <- raster(f)
s_summer <- crop(s_summer, ext)
values(s_summer) <- 0
n_summer <- 0

for (f in FILES) {
  r <- raster(f)
  r <- crop(r, ext)

  d <- date_from_filename(f)
  month <- as.numeric(format(d, '%m'))

  if (month > 3 & month < 10) {
    s_summer <- s_summer + is.na(r)
    n_summer <- n_summer + 1
  }
}

r_summer <- s_summer / n_summer * 100

load('data/common/shapefiles/red_sea_outside.Rdata')
df <- as.data.frame(r_summer, xy=TRUE)

p <- ggplot(df, aes(x, y, fill=layer))
p <- p + geom_tile()
p <- p + scale_fill_gradientn(colours=rev(brewer.pal(7, 'RdYlBu')),
                              breaks=seq(0, 100, 20),
                              labels=as.character(seq(0, 100, 20)),
                              name='%')
p <- p + coord_fixed(xlim=c(32, 46), ylim=c(10,32))
p <- p + geom_polygon(aes(x=long, y=lat, group=group),
                      red.sea.outside, colour='black',
                      fill='tan')
p <- p + ggtitle('Missing values in CCI data for summers between 1997 and 2012')
p <- p + ylab('Latitude') + xlab('Longitude')
p <- p + theme(text=element_text(size=16))

ggsave(paste(outputDir, '/cci_missing_values_summer.png', sep=''), p)