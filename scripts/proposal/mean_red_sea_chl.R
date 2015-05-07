library(raster)
library(scales)
library(ggplot2)
library(yaml)

config <- yaml.load_file('scripts/load/config.yml')
ext <- config$red_sea_extent
ext <- extent(c(ext$lon_min, ext$lon_max, ext$lat_min, ext$lat_max))

outputDir <- 'results/proposal/figures'
dir.create(outputDir, recursive=TRUE)

FILES <- list.files('data/chl_oc_cci/clean/', pattern='*.grd',
                    full.name=TRUE)
N <- length(FILES)
s <- stack()

for (f in FILES) {
  r <- raster(f)
  r <- crop(r, ext)
  s <- stack(s, r)
}

mean_r <- mean(s, na.rm=TRUE)
mean_df <- as.data.frame(mean_r, xy=TRUE)

load('data/common/shapefiles/red_sea_outside.Rdata')

p <- ggplot(mean_df, aes(x, y, fill=layer))
p <- p + geom_tile()
p <- p + scale_fill_gradientn(colours=rev(brewer.pal(7, 'Spectral')),
                          limits=c(0.1, 5), trans='log', oob=squish,
                          name=expression(paste('chl (mg/',m^3,')')),
                          breaks=c(0.2, 1, 5),
                          labels=as.character(c(0.1, 1, 5)))
p <- p + coord_fixed(xlim=c(32, 46), ylim=c(10,32))
p <- p + geom_polygon(aes(x=long, y=lat, group=group),
                      red.sea.outside, colour='black',
                      fill='tan')
p <- p + ggtitle('Chlorophyll average between 1997 and 2012')
p <- p + ylab('Latitude') + xlab('Longitude')
p <- p + theme(text=element_text(size=16))

fn <- paste(outputDir, '/chl_average.png', sep='')
ggsave(fn, plot=p)
