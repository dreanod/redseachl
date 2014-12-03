
build_urls <- function(lat_min, lat_max, lon_min, lon_max, year_start, year_end) {
  url_base <- 'https://rsg.pml.ac.uk/thredds/ncss/grid/CCI_ALL-v1.0-8DAY?'
  url_base <- paste(url_base, 'var=chlor_a&', sep='')
  url_base <- paste(url_base, 'north=', lat_max, '&', sep='')
  url_base <- paste(url_base, 'west=', lon_min, '&', sep='')
  url_base <- paste(url_base, 'east=', lon_max, '&', sep='')
  url_base <- paste(url_base, 'south=', lat_min, '&', sep='')
  url_base <- paste(url_base, 'horizStride=1&', sep='')
  
  URLs <- c()
  
  for (year in year_start:year_end) {
    url <- paste(url_base, 'time_start=', year, '-01-01T00%3A00%3A00Z&', sep='')
    url <- paste(url, 'time_end=', year, '-12-31T00%3A00%3A00Z&', sep='')
    url <- paste(url, 'timeStride=1', sep='')

    URLs <- c(URLs, url)
  }
  
  return(URLs)
}

build_filenames <- function(outDir, year_start, year_end) {
  filenames <- c()
  
  for (year in year_start:year_end){
    filename <- paste('chl_', year, '.nc', sep='')
    filename <- paste(outDir, filename, sep='/')
    
    filenames <- c(filenames, filename)
  }
  
  return(filenames)
}

lat_max <- 35
lat_min <- 5
lon_max <- 55
lon_min <- 25

year_start <- 1997
year_end <- 2012

outDir <- 'data/raw/CHL'

URLs <- build_urls(lat_min, lat_max, lon_min, lon_max, year_start, year_end)
filenames <- build_filenames(outDir, year_start, year_end)
 
for (i in 1:length(URLs)) {
  url <- URLs[i]
  filename <- filenames[i]
  
  # Connection is buggy: Use some flags to make sure to download completely
  flags <- '--retry 999 --retry-max-time 0'
  download.file(url, filename, method='curl', extra=flags)
}

