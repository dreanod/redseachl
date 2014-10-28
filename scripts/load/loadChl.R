sessionInfo()

library(R.utils)
library(raster)
library(RCurl)

lonmin <- 31
lonmax <- 45
latmin <- 10
latmax <- 31
crs <- "+proj=longlat +datum=WGS84"
navalue <- 32767
dataDir <- "../../data"
host <- 'http://oceandata.sci.gsfc.nasa.gov'
path <- 'cgi/getfile'

chl_files <- c()
day_end <- 0
i <- 0
while(day_end < 365) {
  i <- i + 1
  day_start <- (i - 1) * 8 + 1
  day_end <- day_start + 7
  if (day_end > 365) day_end <- 365
  filename <- paste('A2003', sprintf('%03d', day_start), 
                    '2003', sprintf('%03d', day_end), 
                    '.L3m_8D_CHL_chlor_a_9km.bz2', sep='')
  chl_files <- c(chl_files, filename)
}

print('Check if files are on the server')

for (f in chl_files) {
  url <- paste(host, path, f, sep='/')
  if(!url.exists(url)) stop('error, non existing file')
}

print('..............OK')

for (i in 1:length(chl_files)) {
  f <- chl_files[i]
  url <- paste(host, path, f, sep='/')
  
  tempZip  <- tempfile()
  tempDest <- tempfile()
  
  download.file(url, tempZip)
  bunzip2(tempZip, tempDest)
  myRaster <- raster(tempDest)
  
  proj4string(myRaster) <- CRS(crs)
  extent(myRaster) <- c(-180, 180, -90, 90)
  
  redsea <- crop(myRaster, c(lonmin, lonmax, latmin, latmax))
  redsea[redsea == navalue] <- NA
  
  if (i == 1) {
    b <- brick(redsea)
  } else {
    b <- brick(c(b, redsea))
  }
  
  unlink(tempZip)
  unlink(tempDest)
}

writeRaster(b, paste(dataDir, "chl.grd", sep="/"))