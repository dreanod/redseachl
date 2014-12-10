
url <- 'https://www.longpaddock.qld.gov.au/seasonalclimateoutlook/southernoscillationindex/soidatafiles/DailySOI1933-1992Base.txt'
system(paste('wget', url, '-P', 'data/soi/raw'))