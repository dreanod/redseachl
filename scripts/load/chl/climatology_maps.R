library(raster)
library(ggplot2)

FILES <- list.files('data/chl/clean/', pattern='*.grd', full.names=TRUE)

m <- as.matrix(raster(FILES[1]))
m <- array(NA, c(dim(m), length(FILES)))

for (i in 1:length(FILES)) {
  print(FILES[i])
  r <- raster(FILES[i])
  m[,,i] <- as.matrix(r)
}

clim <- apply(m, c(1,2), mean, na.rm=TRUE)
r <- raster(FILES[1])
r[,,] <- clim

df <- as.data.frame(r, xy=TRUE)
names(df) <- c('lon', 'lat', 'chl')

p <- ggplot()