lat_max <- 35
lat_min <- 5
lon_max <- 55
lon_min <- 25

url_base <- 'https://rsg.pml.ac.uk/thredds/ncss/grid/CCI_ALL-v1.0-8DAY?'
url_base <- paste(url_base, 'var=chlor_a&', sep='')
url_base <- paste(url_base, 'north=', lat_max, '&', sep='')
url_base <- paste(url_base, 'west=', lon_min, '&', sep='')
url_base <- paste(url_base, 'east=', lat_max, '&', sep='')
url_base <- paste(url_base, 'south=', lat_min, '&', sep='')
url_base <- paste(url_base, 'horizStride=1&', sep='')

for (year in 1997:2012) {
  url <- paste(url_base, 'time_start=', year, '-01-01T00%3A00%3A00Z&', sep='')
  url <- paste(url, 'time_end=', year, '-12-31T00%3A00%3A00Z&', sep='')
  url <- paste(url, 'timeStride=1', sep='')
  url <- paste('"', url, '"', sep='')
  
  filename <- paste('chl_', year, '.nc', sep='' )
  cmd <- paste('wget', url, '-O', filename, '--wait=0.5 --random-wait --force-html -i - -P ../../data/raw/CHL')
  system(cmd)
}
