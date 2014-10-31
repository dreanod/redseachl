library(R.utils)
library(raster)

out_dir <- 'generated'
NEW_LIST <- paste(out_dir, 'url.list', sep='/')

download_url <- function(url) {
  print(paste('Downloading:', url))
  
  tempZip  <- tempfile()
  tempDest <- tempfile()
  
  download.file(url, tempZip)
  bunzip2(tempZip, tempDest)
  myRaster <- raster(tempDest)
  
  proj4string(myRaster) <- CRS(cst$crs)
  extent(myRaster) <- c(-180, 180, -90, 90)
  
  ext <- cst$extent
  rast_data <- crop(myRaster, c(ext$lonmin, ext$lonmax, ext$latmin, ext$latmax))
  
  filename <- strsplit(url, '/')[[1]]
  filename <- filename[length(filename)]
  filename <- paste(filename, '.grd', sep='')
  writeRaster(rast_data, paste(out_dir, filename, sep="/"))
  
  unlink(tempZip)
  unlink(tempDest)
}

download_list <- function(urls) {
  for (url in urls) {
    download_url(url)
    write(url, file=OLD_LIST, append=TRUE)
  }
}

remove_files <- function(urls) {
  for (url in urls) {
    print(paste('Removing:', url))
  }
}

list_loaded_files <- function() {
  files <- list.files(path=out_dir, pattern='*.grd')
  loaded.files <- c()
  for (i in 1:length(files)) {
    f_split <- strsplit(files[i], split='[.]')[[1]]
    loaded.files <- c(loaded.files, paste(f_split[1:2], collapse='.'))
  }
  return(loaded.files)
}

get_fileID <- function(url) {
  id <- strsplit(url, split='/')[[1]]
  id <- id[length(id)]
  id <- strsplit(id, split='[.]')[[1]]
  id <- paste(id[1:2], collapse='.')
  return(id)
}

con <- file(NEW_LIST, open='r')
url.list <- readLines(con)
close(con)

if (file.exists(OLD_LIST)) {
  con <- file(OLD_LIST, open = 'r')
  url.list.old <- readLines(con)
  close(con)
  
  url.removed.ind <- !(url.list.old %in% url.list)
  url.removed <- url.list.old[url.removed.ind]
  remove_files(url.removed)
  
  url.added.ind <- !(url.list %in% url.list.old)
  url.added <- url.list[url.added.ind]
  if (length(url.added) > 0) {
    download_list(url.added)
  } else {
    print('No new file to download.')
  }
  
  url.unchanged.ind <- url.list %in% url.list.old
  url.unchanged <- url.list[url.unchanged.ind]
  
} else {
  download_list(url.list)
}
