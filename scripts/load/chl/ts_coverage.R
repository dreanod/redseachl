library(raster)
library(ggplot2)
library(yaml)

conf <- yaml.load_file('scripts/load/config.yml')
ext <- conf$red_sea_extent
ext <- extent(c(ext$lon_min, ext$lon_max, ext$lat_min, ext$lat_max))

output_dir <- 'derived/EDA/chl/missing_values'
dir.create(output_dir, recursive=TRUE)

FILES <- list.files('data/chl/clean', pattern='*.grd', full.names=TRUE)

s <- NULL

for (f in FILES) {
  print(f)
  r <- raster(f)
  r <- crop(r, ext)
  r <- as.matrix(r)
  if (is.null(s)) {
    s <- is.na(r)
  }
  else {
    s <- s + is.na(r)
  }
}

mask <- s == length(FILES)
r <- crop(raster(f), ext)
r[,] <- mask

cds1 <- rbind(c(32,25), c(34,25), c(34,20), c(32,20), c(32,25))
pols <- SpatialPolygons(list(Polygons(list(Polygon(cds1)), 1)))
ind <- cellFromPolygon(r, pols)
r[ind[[1]]] <- TRUE
mask <- r

## Now compute missing values TS
date_from_filename <- function(f) {
  b <- basename(f)
  b <- strsplit(b, '[.]')[[1]]
  b <- b[1]

  y <- substring(b, 2, 5)
  d <- as.numeric(substring(b, 6, 8))

  t <- as.Date(d - 1, origin=paste(y, '-01-01-', sep=''))
  return(t)
}

m <- vector()
d <- NULL

for (f in FILES) {
  r <- raster(f)
  r <- crop(r, extent(mask))
  v <- as.vector(r)
  v <- v[!as.vector(mask)]
  m <- c(m, mean(is.na(v)))
  if (is.null(d)) {
    d <- date_from_filename(f)
  } else {
    d <- c(d, date_from_filename(f))
  }
}

df <- data.frame(date=d, missing=m)
drange <- seq(as.Date('2003-01-01'), as.Date('2014-01-01'), 'year')
dlabels <- as.character(seq(2003, 2014))
p <- ggplot(df, aes(x=date, y=missing)) + geom_line()
p <- p + scale_x_date(breaks=drange, labels=dlabels)
p <- p + ggtitle('ratio of CHL missing values in the Red Sea (MODIS L3 4km)')
fn <- paste(output_dir, '/missing_val_red_sea_ts.png', sep='')
ggsave(fn, plot=p, width=25, height=5, units='cm')


## Compute missing values climatology

df$month_day <- NA

fun <- function(x) {
  substring(x[1], 1, 4) <- '2000'
  return(x[1])
}
apply(df, 1, fun)