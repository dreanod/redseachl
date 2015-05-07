library(raster)
library(ncdf)
library(abind)

U_FILES <- list.files('data/wind/raw', full.names=TRUE,
                      pattern='*u10.nc')
V_FILES <- list.files('data/wind/raw', full.names=TRUE,
                      pattern='*v10.nc')

get_daily_wind <- function(f, var) {
  nc.file <- open.ncdf(f)
  w <- get.var.ncdf(nc.file, var)
  return(w)
}

daily_average <- function(w) {
  out_dim <- dim(w)
  out_dim[3] <- (out_dim[3] - 1) / 8
  avr <- array(dim=out_dim)
  for (i in 1:out_dim[3]) {
    avr[,,i] <- apply(w[,,((i-1)*8+1):(i*8)], c(1,2), mean)
  }
  return(avr)
}

u_data <- NULL
for (f in U_FILES) {
  w <- get_daily_wind(f, 'uwnd')
  avr <- daily_average(w)
  u_data <- abind(u_data, avr, along=3)
}
u_data <- u_data[,249:1,]

v_data <- NULL
for (f in V_FILES) {
  w <- get_daily_wind(f, 'vwnd')
  avr <- daily_average(w)
  v_data <- abind(v_data, avr, along=3)
}
v_data <- v_data[,249:1,]

r <- raster('data/wind/raster_info/wind.tiff')

U_b <- brick(r, values=FALSE, nl=731)
values(U_b) <- u_data

V_b <- brick(r, values=FALSE, nl=731)
values(V_b) <- v_data

dir.create('data/wind/aggregate', recursive=TRUE)
writeRaster(U_b, 'data/wind/aggregate/uwnd.grd', overwrite=TRUE)
writeRaster(V_b, 'data/wind/aggregate/vwnd.grd', overwrite=TRUE)