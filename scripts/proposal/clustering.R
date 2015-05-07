library(mclust)

chl <- read.csv('scripts/proposal/data/log_chl_seawifs_filled.csv')

outputDir <- 'results/proposal/figures'
dir.create(outputDir, recursive=TRUE)

data <- chl[4:123]

res <- Mclust(data, G=5)
chl$cluster <- factor(res$classification)

library(ggplot2)

load('data/common/shapefiles/red_sea_outside.Rdata')

p <- ggplot(chl, aes(x=lon, y=lat, fill=cluster))
p <- p + geom_tile()
p <- p + scale_colour_brewer(palette='Set2')
p <- p + coord_fixed(xlim=c(32, 46), ylim=c(10,32))
p <- p + geom_polygon(aes(x=long, y=lat, group=group),
                      red.sea.outside, colour='black',
                      fill='tan')
p <- p + ggtitle('GMM clustering with 5 clusters')
p <- p + ylab('Latitude') + xlab('Longitude')
p <- p + theme(text=element_text(size=16))

fn <- paste(outputDir, '/clusters_k5.png', sep='')
ggsave(fn, plot=p)