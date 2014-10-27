library(R.utils)
library(raster)

url <- "http://oceandata.sci.gsfc.nasa.gov/cgi/getfile/A20021852002192.L3m_8D_CHL_chlor_a_9km.bz2"

tempZip  <- tempfile()
tempDest <- tempfile()

download.file(url, tempZip)
bunzip2(tempZip, tempDest)

myRaster <- raster(tempDest)

unlink(tempZip)
unlink(tempDest)

plot(myRaster)

proj4string(myRaster) <- CRS("+proj=longlat +datum=WGS84")
extent(myRaster) <- c(-180, 180, -90, 90)

plot(myRaster)

x_min <- 31
x_max <- 45
y_min <- 10
y_max <- 31
redsea <- crop(myRaster, c(x_min, x_max, y_min, y_max))
redsea[redsea == 32767] <- NA


writeRaster(redsea, "../../data/redseadata.grd")

