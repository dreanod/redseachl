library(R.utils)
library(raster)
library(RCurl)
library(yaml)

cst <- yaml.load_file('config.yml')
dataDir <- "../../data"

url_list <- c()
for (year in cst$year_begin:cst$year_end) {
  day_end <- 0
  i <- 0
  nb_days = 365
  if (year %% 4 == 0) nb_days <- 366 # bissextile years
  while(day_end < nb_days) {
    i <- i + 1
    day_start <- (i - 1) * 8 + 1
    day_end <- day_start + 7
    if (day_end > nb_days) day_end <- nb_days
    filename <- paste('A', year, sprintf('%03d', day_start), 
                      year, sprintf('%03d', day_end), 
                      cst$chl_file_suffix, sep='')
    url <- paste(cst$chl_url, filename, sep='/')
    url_list <- c(url_list, url)
  }
}
print('Check if files are on the server')

for (url in url_list) {
  if(!url.exists(url)) stop(paste('error, non existing file:', url))
}

print('..............OK')

print('Downloading CHL files')

for (i in 1:length(url_list)) {
  url <- url_list[i]
  
  tempZip  <- tempfile()
  tempDest <- tempfile()
  
  download.file(url, tempZip)
  bunzip2(tempZip, tempDest)
  myRaster <- raster(tempDest)
  
  proj4string(myRaster) <- CRS(cst$crs)
  extent(myRaster) <- c(-180, 180, -90, 90)
  
  ext <- cst$extent
  redsea <- crop(myRaster, c(ext$lonmin, ext$lonmax, ext$latmin, ext$latmax))
  redsea[redsea == navalue] <- NA
  
  if (i == 1) {
    b <- brick(redsea)
  } else {
    b <- brick(c(b, redsea))
  }
  
  unlink(tempZip)
  unlink(tempDest)
}

print('...................OK')

writeRaster(b, paste(dataDir, "chl.grd", sep="/"))
