library(R.utils)
library(raster)

out_dir <- file.path('.',  'generated')
to_download_file <- paste(out_dir, 'chl_modis_8days_9km.list', sep='/')
data_dir <- file.path(out_dir, 'chl_modis_8days_9km')
dir.create(data_dir)

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

download_list <- function(files) {
  if (length(files) == 0) {
    print('Nothing to download')
  }
  for (f in files) {
    print(paste('Downloading:', f))
  }
}

remove_files <- function(files) {
  if (length(files) == 0) {
    print('Nothing to remove')
  }
  
  for (f in files) {
    print(paste('Removing:', f))
  }
}

list_loaded_files <- function() {
  files <- list.files(path=data_dir, pattern='*.grd')
  loaded.files <- c()
  for (i in 1:length(files)) {
    f_split <- strsplit(files[i], split='[.]')[[1]]
    loaded.files <- c(loaded.files, paste(f_split[1:3], collapse='.'))
  }
  return(loaded.files)
}

con <- file(to_download_file, open='r')
to_download <- readLines(con)
close(con)

downloaded <- list_loaded_files()

if (length(downloaded) == 0) {
  download_files(to_download)
} else {
  to_remove_ind <- !(downloaded %in% to_download)
  to_remove <- downloaded[to_remove_ind]
  remove_files(to_remove)
  
  will_download_ind <- !(to_download %in% downloaded)
  will_download <- to_download[will_download_ind]
  download_list(will_download)
}


