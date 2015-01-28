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

fun <- function(x) {
  substring(x[1], 1, 4) <- '2000'
  return(x[1])
}
df$month_day <- apply(df, 1, fun)

d_clim <- sort(unique(df$month_day))
d_clim <- c(d_clim[1:8], d_clim[seq(9, length(d_clim), 2)])
m_clim <- vector()

for (t in d_clim) {
  print(t)
  df_temp1 <- subset(df, month_day==t)
  df_temp2 <- subset(df, month_day==as.Date(1, origin=t))
  df_temp <- rbind(df_temp1, df_temp2)
  print(nrow(df_temp))
  m_clim <- c(m_clim, mean(df_temp$missing))
}

df_clim <- data.frame(month_day=d_clim, missing=m_clim)
df_clim$month_day <- as.Date(df_clim$month_day)

drange <-seq(as.Date('2000-01-01'), as.Date('2000-12-31'), 'month')
dlabels <- format(drange, "%b")
p <- ggplot(df_clim, aes(x=month_day, y=missing))
p <- p + geom_line() 
p <- p + scale_x_date(breaks=drange, labels=dlabels)
p <- p + ggtitle('ratio of missing values in Red Sea (climatology from 2002 to 2014)')
fn <- paste(output_dir, '/missing_val_red_sea_climatology.png', sep='')
ggsave(fn, plot=p)