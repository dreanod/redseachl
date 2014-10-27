library(R.utils)
library(raster)

lonmin <- 31
lonmax <- 45
latmin <- 10
latmax <- 31
crs <- "+proj=longlat +datum=WGS84"
navalue <- 32767
dataDir <- "../../data"
url <- "http://oceandata.sci.gsfc.nasa.gov/cgi/getfile/A20021852002192.L3m_8D_CHL_chlor_a_9km.bz2"

tempZip  <- tempfile()
tempDest <- tempfile()

download.file(url, tempZip)
bunzip2(tempZip, tempDest)
myRaster <- raster(tempDest)

unlink(tempZip)
unlink(tempDest)

proj4string(myRaster) <- CRS(crs)
extent(myRaster) <- c(-180, 180, -90, 90)

redsea <- crop(myRaster, c(lonmin, lonmax, latmin, latmax))
redsea[redsea == navalue] <- NA

writeRaster(redsea, paste(dataDir, "redseadata.grd"))
